import 'package:graei/features/producto/data/models/foto_model.dart';
import 'package:graei/features/producto/domain/repositories/foto_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';
import 'package:graei/features/producto/domain/repositories/producto_repository.dart';

@lazySingleton
class BuscarProductos
{
    final ProductoRepository repository;
    final FotoRepository _repositoryFoto;
    
    BuscarProductos(this.repository, this._repositoryFoto);
    
    Future<List<Producto>> execute(String query, int limit, int offset) async
    {
        List<Producto> productos = await repository.buscarProductos(query, limit, offset);

        if (productos.isEmpty) return [];
        
        final ids = productos.map((p) => p.id!).toList();
        final fotos = await _repositoryFoto.obtenerRutasFotosPorProductoRangoId(ids);

        return productos.map((producto)
        {
            final fotosDelProducto = fotos
            .where((foto) => foto.productoId == producto.id)
            .toList();

            return producto.copyWith(fotos: fotosDelProducto);
        }).toList();
    }
}