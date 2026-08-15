import 'package:graei/core/atomic_process/atomic_session.dart';
import 'package:graei/features/producto/data/models/foto_model.dart';

abstract class FotoRepository
{
    Future<List<String>> obtenerRutasFotosPorProductoId(int productoId);
    Future<void> registrarFotosPorProductoId(int productoId, List<ProductoFoto> fotos, { AtomicSession? atomicSession });
    Future<void> eliminarFotosPorProductoId(int productoId, { AtomicSession? atomicSession });
    Future<List<ProductoFoto>> obtenerRutasFotosPorProductoRangoId(List<int> productosId);
}