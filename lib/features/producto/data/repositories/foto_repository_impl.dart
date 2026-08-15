import 'package:injectable/injectable.dart';
import 'package:graei/core/atomic_process/atomic_session.dart';
import 'package:graei/features/producto/data/datasources/foto_local_datasource.dart';
import 'package:graei/features/producto/data/models/foto_model.dart';
import 'package:graei/features/producto/domain/repositories/foto_repository.dart';

@LazySingleton(as: FotoRepository)
class FotoRepositoryImpl implements FotoRepository
{
    final FotoLocalDataSource _localDataSource;
    FotoRepositoryImpl({required this._localDataSource});
    
    @override
    Future<List<String>> obtenerRutasFotosPorProductoId(int productoId)
    {
        return _localDataSource.obtenerRutasFotosPorProductoId(productoId);
    }

    @override
    Future<void> registrarFotosPorProductoId(int productoId, List<ProductoFoto> fotos, { AtomicSession? atomicSession })
    {
        return _localDataSource.registrarFotosPorProductoId(productoId, fotos, atomicSession: atomicSession);
    }

    @override
    Future<void> eliminarFotosPorProductoId(int productoId, { AtomicSession? atomicSession })
    {
        return _localDataSource.eliminarFotosPorProductoId(productoId, atomicSession: atomicSession);
    }

    @override
    Future<List<ProductoFoto>> obtenerRutasFotosPorProductoRangoId(List<int> productosId)
    {
        return _localDataSource.obtenerRutasFotosPorProductoRangoId(productosId: productosId);
    }
}