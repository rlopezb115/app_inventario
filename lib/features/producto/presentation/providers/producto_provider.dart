import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graei/core/di/injection_names.dart';
import 'package:graei/core/extensions/cadena_extension.dart';
import 'package:graei/core/utils/cancellation_token.dart';
import 'package:graei/features/producto/domain/repositories/media_storage_repository.dart';
import 'package:graei/features/producto/domain/usecases/actualizar_producto.dart';
import 'package:injectable/injectable.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';
import 'package:graei/features/producto/domain/usecases/buscar_productos.dart';
import 'package:graei/features/producto/domain/usecases/eliminar_producto.dart';
import 'package:graei/features/producto/domain/usecases/obtener_productos_paginados.dart';
import 'package:graei/features/producto/domain/usecases/registrar_producto.dart';

@injectable
class ProductoProvider with ChangeNotifier
{
    // Inyección de Casos de Uso
    final ObtenerProductosPaginados _obtenerProductosPaginadosUC;
    final BuscarProductos _buscarProductosUC;
    final RegistrarProducto _registrarProductoUC;
    final ActualizarProducto _actualizarProductoUC;
    final EliminarProducto _eliminarProductoUC;

    // 2. Abstracción del Almacenamiento Local (para captura y borrado de borrador)
    final MediaStorageRepository _mediaStorageRepository;
    
    // Estados de la UI
    List<Producto> _productos = [];
    List<Producto> get productos => _productos;

    List<String> _rutasFotosSeleccionadas = [];
    List<String> get rutasFotosSeleccionadas => _rutasFotosSeleccionadas;

    final List<String> _fotosEliminadasEnEdicion = [];
    
    bool _isLoading = false;
    bool get isLoading => _isLoading;

    String? _errorMessage;
    String? get errorMessage => _errorMessage;

    int _offset = 0;
    final int _limit = 20;
    bool _tieneMasDatos = true;
    String _filtroActivo = "";
    Timer? _debounce;
    
    ProductoProvider({
        required this._obtenerProductosPaginadosUC,
        required this._buscarProductosUC,
        required this._registrarProductoUC,
        required this._actualizarProductoUC,
        required this._eliminarProductoUC,
        @Named(InjectionNames.mediaStorageLocal) required this._mediaStorageRepository,
    });

    Future<void> inicializarCatalogo() async
    {
        _productos.clear();
        _offset = 0;
        _tieneMasDatos = true;
        _filtroActivo = "";
        await cargarSiguienteBloque();
    }

    Future<void> cargarSiguienteBloque() async
    {
        if (_isLoading || !_tieneMasDatos) return;

        _isLoading = true;
        _errorMessage = null;
        notifyListeners();

        try
        {
            final List<Producto> nuevosProductos = _filtroActivo.isEmpty
                ? await _obtenerProductosPaginadosUC.execute(_limit, _offset)
                : await _buscarProductosUC.execute(_filtroActivo, _limit, _offset);

            if (nuevosProductos.length < _limit)
            {
                _tieneMasDatos = false;
            }

            _productos.addAll(nuevosProductos);
            _offset += _limit;
    
        } catch (e) {
            
            _errorMessage = e.toString();

        } finally {
      
            _isLoading = false;
            notifyListeners();
        }
    }

    // NUEVO: Implementa debounce de 300ms[cite: 3]
    void cambiarFiltroBusqueda(String texto)
    {
        if (_debounce?.isActive ?? false) _debounce!.cancel();

        _debounce = Timer(const Duration(milliseconds: 300), () async
        {
            _filtroActivo = texto.trim();
            _productos.clear();
            _offset = 0;
            _tieneMasDatos = true;
            await cargarSiguienteBloque();
        });
    }

    void inicializarFotos(List<String> fotosExistentes)
    {
        _rutasFotosSeleccionadas = List.from(fotosExistentes);
        _fotosEliminadasEnEdicion.clear();
        notifyListeners();
    }

    Future<void> capturarFoto(int indice) async
    {
        final String? rutaTmp = await _mediaStorageRepository.capturarImagenTemporal(index: indice);
        if (rutaTmp.esDiferenteDeNuloYVacio)
        {
            _rutasFotosSeleccionadas.add(rutaTmp!);
            notifyListeners();
        }
    }

    Future<void> removerFoto(int indice) async
    {
        final String rutaRemovida = _rutasFotosSeleccionadas.removeAt(indice);

        if (rutaRemovida.contains('temp_prod_'))
        {
            await _mediaStorageRepository.eliminarArchivoFisico(rutaRemovida);
        }
        else
        {
            _fotosEliminadasEnEdicion.add(rutaRemovida);
        }

        notifyListeners();
    }

    Future<void> limpiarBusqueda() async
    {
        await inicializarCatalogo();
    }

    void _setLoading(bool value)
    {
        _isLoading = value;
        _errorMessage = null;
        notifyListeners();
    }

    void _setError(String error)
    {
        _isLoading = false;
        _errorMessage = error;
        notifyListeners();
    }

    Future<bool> registrarNuevoProducto(Producto producto, { CancellationToken? cancelToken }) async
    {
        bool success = false;
        _setLoading(true);
        
        try
        {
            await _registrarProductoUC.execute(
                producto,
                _rutasFotosSeleccionadas,
                cancelToken: cancelToken
            );

            await inicializarCatalogo();
            success = true;
        }
        catch (e)
        {
            _setError(e.toString());
        }
        finally
        {
            _setLoading(false);
        }

        return success;
    }

    Future<bool> actualizarProducto(Producto producto, { CancellationToken? cancelToken }) async
    {
        _setLoading(true);
        bool success = false;

        try
        {
            if (await _actualizarProductoUC.execute(
                producto,
                _rutasFotosSeleccionadas,
                _fotosEliminadasEnEdicion,
                cancelToken: cancelToken
            ))
            {
                final index = _productos.indexWhere((p) => p.id == producto.id);
                if (index != -1)
                {
                    _productos[index] = producto;
                    notifyListeners();
                    success = true;
                }
            }
        }
        catch (e)
        {
            _setError(e.toString());
        }
        finally
        {
            _setLoading(false);
        }

        return success;
    }

    Future<bool> eliminarProducto(int id) async
    {
        bool success = false;
        try
        {
            await _eliminarProductoUC.execute(id);
            _productos.removeWhere((p) => p.id == id);
            notifyListeners();
            success = true;
        }
        catch(e)
        {
            _setError(e.toString());
        }
        finally
        {
            _setLoading(false);
        }

        return success;
    }
}