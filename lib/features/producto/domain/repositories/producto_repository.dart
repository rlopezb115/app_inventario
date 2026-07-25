import 'package:graei/core/atomic_process/atomic_session.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';

abstract class ProductoRepository
{
    Future<List<Producto>> obtenerProductosPaginados(int limit, int offset);
    Future<List<Producto>> buscarProductos(String query, int limit, int offset);
    Future<int> registrarProducto(Producto producto, { AtomicSession? atomicSession });
    Future<bool> actualizarProductoTransaccional(Producto producto, { AtomicSession? atomicSession });
    Future<void> eliminarProducto(int id, { AtomicSession? atomicSession });
}