class ProductoFoto
{
	int? id;
  	int? productoId;
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
}