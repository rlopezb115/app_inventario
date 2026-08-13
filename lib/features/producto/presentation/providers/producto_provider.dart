// ========================================================
// ARCHIVO: lib/features/producto/presentation/providers/producto_provider.dart
// ========================================================
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graei/core/utils/cancellation_token.dart';
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
    final ObtenerProductosPaginados _obtenerProductosPaginadosUC;
    final BuscarProductos _buscarProductosUC;
    final RegistrarProducto _registrarProductoUC;
    final ActualizarProducto _actualizarProductoUC;
    final EliminarProducto _eliminarProductoUC;
    // final MediaStorageRepository _mediaStorageRepository;
    
    List<Producto> _productos = [];
    List<Producto> get productos => _productos;

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
        // @Named(InjectionNames.mediaStorageLocal) required this._mediaStorageRepository,
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

    Future<void> limpiarBusqueda() async
    {
        _filtroActivo = "";
        _productos.clear();
        _offset = 0;
        _tieneMasDatos = true;
        notifyListeners(); // IMPORTANTE: Notifica a los listeners que la lista cambió
        
        await cargarSiguienteBloque();
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

    /// Recarga la lista desde cero manteniendo el filtro de búsqueda que esté activo en el momento.
    Future<void> recargarCatalogoConFiltroActual() async
    {
        _productos.clear();
        _offset = 0;
        _tieneMasDatos = true;
        await cargarSiguienteBloque();
    }

    Future<bool> registrarNuevoProducto(
        Producto producto, 
        List<String> rutasFotos, { 
        CancellationToken? cancelToken 
    }) async
    {
        bool success = false;
        _setLoading(true);
        
        try
        {
            await _registrarProductoUC.execute(
                producto,
                rutasFotos,
                cancelToken: cancelToken
            );

            _setLoading(false);

            // Refrescamos el catálogo usando el filtro que esté activo actualmente
            await recargarCatalogoConFiltroActual();
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

    Future<bool> actualizarProducto(
        Producto producto, 
        List<String> rutasFotos, 
        List<String> fotosEliminadas, { 
        CancellationToken? cancelToken 
    }) async
    {
        _setLoading(true);
        bool success = false;

        try
        {
            if (await _actualizarProductoUC.execute(
                producto,
                rutasFotos,
                fotosEliminadas,
                cancelToken: cancelToken
            ))
            {
                final index = _productos.indexWhere((p) => p.id == producto.id);
                if (index != -1)
                {
                    _productos[index] = producto;
                }
                notifyListeners();
                success = true;
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