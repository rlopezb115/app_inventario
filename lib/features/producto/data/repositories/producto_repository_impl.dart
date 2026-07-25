import 'package:injectable/injectable.dart';
import 'package:graei/core/atomic_process/atomic_session.dart';
import 'package:graei/features/producto/data/datasources/producto_local_datasource.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';
import 'package:graei/features/producto/domain/repositories/producto_repository.dart';

@LazySingleton(as: ProductoRepository)
class ProductoRepositoryImpl implements ProductoRepository
{
    final ProductoLocalDataSource localDataSource;
    ProductoRepositoryImpl({required this.localDataSource});

    @override
    Future<List<Producto>> obtenerProductosPaginados(int limit, int offset)
    {
        return localDataSource.obtenerProductosPaginados(limit, offset);
    }

    @override
    Future<List<Producto>> buscarProductos(String query, int limit, int offset)
    {
        return localDataSource.buscarProductos(query, limit, offset);
    }

    @override
    Future<int> registrarProducto(Producto producto, { AtomicSession? atomicSession })
    {
        return localDataSource.registrarProductoTransaccional(producto, atomicSession: atomicSession);
    }

    @override
    Future<bool> actualizarProductoTransaccional(Producto producto, { AtomicSession? atomicSession })
    {
        return localDataSource.actualizarProductoTransaccional(producto, atomicSession: atomicSession);
    }

    @override
    Future<void> eliminarProducto(int id, { AtomicSession? atomicSession })
    {
        return localDataSource.eliminarProducto(id, atomicSession: atomicSession);
    }
}