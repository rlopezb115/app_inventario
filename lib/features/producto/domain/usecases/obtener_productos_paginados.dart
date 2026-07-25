import 'package:injectable/injectable.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';
import 'package:graei/features/producto/domain/repositories/producto_repository.dart';

@lazySingleton
class ObtenerProductosPaginados
{
    final ProductoRepository repository;
    
    ObtenerProductosPaginados(this.repository);
    
    Future<List<Producto>> execute(int limit, int offset)
    {
        return repository.obtenerProductosPaginados(limit, offset);
    }
}