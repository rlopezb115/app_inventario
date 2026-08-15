class ProductoFoto
{
	final int? id;
  	final int? productoId;
  	final String rutaFoto;

  	ProductoFoto({
    	this.id,
    	this.productoId,
    	required this.rutaFoto,
  	});

  	// Convierte el objeto a un Map para insertarlo en SQLite
  	Map<String, dynamic> toMap()
	{
    	return {
      		'id': id,
      		'producto_id': productoId,
      		'ruta_foto': rutaFoto,
    	};
  	}

  	// Crea un objeto ProductoFoto a partir de un Map de la Base de Datos
  	factory ProductoFoto.fromMap(Map<String, dynamic> map)
	{
    	return ProductoFoto(
      		id: map['id'],
      		productoId: map['producto_id'],
      		rutaFoto: map['ruta_foto'],
    	);
  	}

    ProductoFoto copyWith({
        int? id,
        int? productoId,
        String? rutaFoto,
    }) {
        return ProductoFoto(
            id: id ?? this.id,
            productoId: productoId ?? this.productoId,
            rutaFoto: rutaFoto ?? this.rutaFoto
        );
    }
}