import 'package:injectable/injectable.dart';

import 'package:graei/core/atomic_process/atomic_process_manager.dart';
import 'package:graei/core/di/injection_names.dart';
import 'package:graei/core/exceptions/process_aborted_exception.dart';
import 'package:graei/core/extensions/numero_extension.dart';
import 'package:graei/core/utils/cancellation_token.dart';

import 'package:graei/features/producto/data/models/producto_model.dart';
import 'package:graei/features/producto/domain/repositories/foto_repository.dart';
import 'package:graei/features/producto/domain/repositories/media_storage_repository.dart';
import 'package:graei/features/producto/domain/repositories/producto_repository.dart';

@lazySingleton
class ActualizarProducto
{
    final ProductoRepository _productoRepository;
    final FotoRepository _fotoRepository;
    final MediaStorageRepository _mediaStorageRepository;
    final AtomicProcessManager _atomicProcessManager;
    
    ActualizarProducto({
        required this._productoRepository,
        required this._fotoRepository,
        @Named(InjectionNames.mediaStorageLocal) required this._mediaStorageRepository,
        @Named(InjectionNames.dbAtomic) required this._atomicProcessManager,
    });
    
    Future<bool> execute(
        Producto producto,
        List<String> rutasFotosActuales,
        List<String> fotosEliminadasEnEdicion, {
            CancellationToken? cancelToken 
    }) async
    {
        bool success = false;
        if (cancelToken != null && cancelToken.isCancelled)
        {
            throw ProcessAbortedException(cancelToken.reason!);
        }

        final List<String> rutasPermanentes =
            await _mediaStorageRepository.persistirImagenesTemporales(rutasFotosActuales);

        try 
        {
            if (!producto.id.esMayorACero)
            {
                throw Exception('El valor del id del producto no se encuentra.');
            }

            await _atomicProcessManager.runInAtomicProcess((session) async
            {
                if (!await _productoRepository.actualizarProductoTransaccional(producto, atomicSession: session))
                {
                    throw Exception('Problemas al actualizar el producto, intente mas tarde.');
                }

                if (cancelToken != null && cancelToken.isCancelled)
                {
                    session.abort(cancelToken.reason!);
                }

                await _fotoRepository.eliminarFotosPorProductoId(producto.id!, atomicSession: session);
                if (cancelToken != null && cancelToken.isCancelled)
                {
                    session.abort(cancelToken.reason!);
                }

                if (rutasPermanentes.isNotEmpty)
                {
                    await _fotoRepository.registrarFotosPorProductoId(
                        producto.id!, 
                        producto.fotos,
                        atomicSession: session
                    );
                }

                success = true;
            });

            if (fotosEliminadasEnEdicion.isNotEmpty)
            {
                await _mediaStorageRepository.eliminarArchivosFisicos(fotosEliminadasEnEdicion);
            }
        }
        on ProcessAbortedException {
            // print('El proceso de ''Registrar Producto'' fue abortado y revertido: ${e.message}');
        }
        catch (e)
        {
            // print('Ocurrió un error en la base de datos, se aplicó un Rollback automático: $e');
            rethrow;
        }

        return success;
    }
}