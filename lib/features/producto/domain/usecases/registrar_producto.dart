import 'package:injectable/injectable.dart';

import 'package:graei/core/atomic_process/atomic_process_manager.dart';
import 'package:graei/core/di/injection_names.dart';
import 'package:graei/core/exceptions/process_aborted_exception.dart';
import 'package:graei/core/utils/cancellation_token.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';
import 'package:graei/features/producto/domain/repositories/foto_repository.dart';
import 'package:graei/features/producto/domain/repositories/media_storage_repository.dart';
import 'package:graei/features/producto/domain/repositories/producto_repository.dart';

@lazySingleton
class RegistrarProducto
{
    final ProductoRepository _productoRepository;
    final FotoRepository _fotoRepository;
    final MediaStorageRepository _mediaStorageRepository;
    final AtomicProcessManager _atomicProcessManager;
    
    RegistrarProducto({
        required this._productoRepository,
        required this._fotoRepository,
        @Named(InjectionNames.mediaStorageLocal) required this._mediaStorageRepository,
        @Named(InjectionNames.dbAtomic) required this._atomicProcessManager,
    });
    
    Future<int> execute(
        Producto producto,
        List<String> rutasFotosTemporales, {
            CancellationToken? cancelToken 
    }) async
    {
        if (cancelToken != null && cancelToken.isCancelled)
        {
            throw ProcessAbortedException(cancelToken.reason!);
        }

        // 1. Mover imágenes temporales a almacenamiento permanente
        final List<String> rutasPermanentes = 
            await _mediaStorageRepository.persistirImagenesTemporales(rutasFotosTemporales);

        try 
        {
            int productoId = 0;
            await _atomicProcessManager.runInAtomicProcess((session) async {

                productoId = await _productoRepository.registrarProducto(
                    producto, 
                    atomicSession: session
                );

                if (cancelToken != null && cancelToken.isCancelled)
                {
                    session.abort(cancelToken.reason!);
                }

                if (rutasPermanentes.isNotEmpty)
                {
                    await _fotoRepository.registrarFotosPorProductoId(productoId, producto.fotos, atomicSession: session);
                }
            });

            return productoId;
        }
        on ProcessAbortedException
        {
            // print('El proceso de ''Registrar Producto'' fue abortado y revertido: ${e.message}');
            rethrow;
        }
        catch (e)
        {
            await _mediaStorageRepository.eliminarArchivosFisicos(rutasPermanentes);
            rethrow;
        }
    }
}