import 'package:graei/features/producto/domain/repositories/foto_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';
import 'package:graei/features/producto/domain/repositories/producto_repository.dart';

@lazySingleton
class ObtenerProductosPaginados
{
    final ProductoRepository _repository;
    final FotoRepository _fotoRepository;
    
    ObtenerProductosPaginados(this._repository, this._fotoRepository);
    
    Future<List<Producto>> execute(int limit, int offset) async
    {
        final productos = await _repository.obtenerProductosPaginados(limit, offset);
        if (productos.isEmpty) return [];

        // Cargar las fotos asociadas a la lista de productos
        final ids = productos.map((p) => p.id!).toList();
        final fotos = await _fotoRepository.obtenerRutasFotosPorProductoRangoId(ids);

        return productos.map((producto) {
            final fotosDelProducto = fotos
                .where((foto) => foto.productoId == producto.id)
                .toList();

            return producto.copyWith(fotos: fotosDelProducto);
        }).toList();
    }
}