import 'package:injectable/injectable.dart';
import 'package:graei/core/atomic_process/atomic_session.dart';
import 'package:graei/features/producto/data/datasources/producto_local_datasource.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';
import 'package:graei/features/producto/domain/repositories/producto_repository.dart';

@LazySingleton(as: ProductoRepository)
class ProductoRepositoryImpl implements ProductoRepository
{
    final ProductoLocalDataSource _localDataSource;
    ProductoRepositoryImpl({required this._localDataSource});

    @override
    Future<List<Producto>> obtenerProductosPaginados(int limit, int offset)
    {
        return _localDataSource.obtenerProductosPaginados(limit, offset);
    }

    @override
    Future<List<Producto>> buscarProductos(String query, int limit, int offset)
    {
        return _localDataSource.buscarProductos(query, limit, offset);
    }

    @override
    Future<int> registrarProducto(Producto producto, { AtomicSession? atomicSession })
    {
        return _localDataSource.registrarProductoTransaccional(producto, atomicSession: atomicSession);
    }

    @override
    Future<bool> actualizarProductoTransaccional(Producto producto, { AtomicSession? atomicSession })
    {
        return _localDataSource.actualizarProductoTransaccional(producto, atomicSession: atomicSession);
    }

    @override
    Future<void> eliminarProducto(int id, { AtomicSession? atomicSession })
    {
        return _localDataSource.eliminarProducto(id, atomicSession: atomicSession);
    }
}