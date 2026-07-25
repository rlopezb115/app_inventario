import 'package:graei/features/producto/domain/repositories/media_storage_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:graei/core/atomic_process/atomic_process_manager.dart';
import 'package:graei/core/di/injection_names.dart';
import 'package:graei/core/exceptions/process_aborted_exception.dart';
import 'package:graei/core/utils/cancellation_token.dart';
import 'package:graei/features/producto/domain/repositories/foto_repository.dart';
import 'package:graei/features/producto/domain/repositories/producto_repository.dart';

@lazySingleton
class EliminarProducto
{
    final ProductoRepository _productoRepository;
    final FotoRepository _fotoRepository;
    final MediaStorageRepository _mediaStorageRepository;
    final AtomicProcessManager _atomicProcessManager;

    EliminarProducto({
        required this._productoRepository,
        required this._fotoRepository,
        @Named(InjectionNames.mediaStorageLocal) required this._mediaStorageRepository,
        @Named(InjectionNames.dbAtomic) required this._atomicProcessManager,
    });

    Future<void> execute(int id, { CancellationToken? cancelToken }) async
    {
        final rutasFotos = await _fotoRepository.obtenerRutasFotosPorProductoId(id);

        if (cancelToken != null && cancelToken.isCancelled)
        {
            throw ProcessAbortedException(cancelToken.reason!);
        }

        try 
        {
            await _atomicProcessManager.runInAtomicProcess((session) async
            {
                await _fotoRepository.eliminarFotosPorProductoId(id, atomicSession: session);
                if (cancelToken != null && cancelToken.isCancelled)
                {
                    session.abort(cancelToken.reason!);
                }

                await _productoRepository.eliminarProducto(id, atomicSession: session);
                if (cancelToken != null && cancelToken.isCancelled)
                {
                    session.abort(cancelToken.reason!);
                }
            });

            // Borrado físico del almacenamiento
            if (rutasFotos.isNotEmpty)
            {
                for (final ruta in rutasFotos)
                {
                    await _mediaStorageRepository.eliminarArchivoFisico(ruta);
                }
            }
        }
        on ProcessAbortedException {
            //print('El proceso de eliminación fue abortado y revertido: ${e.message}');
            rethrow;
        }
        catch (e)
        {
            //print('Ocurrió un error en la base de datos, se aplicó un Rollback automático: $e');
            rethrow;
        }
    }
}