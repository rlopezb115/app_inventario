import 'package:injectable/injectable.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';
import 'package:graei/features/producto/domain/repositories/producto_repository.dart';

@lazySingleton
class BuscarProductos
{
    final ProductoRepository repository;
    
    BuscarProductos(this.repository);
    
    Future<List<Producto>> execute(String query, int limit, int offset)
    {
        return repository.buscarProductos(query, limit, offset);
    }
}