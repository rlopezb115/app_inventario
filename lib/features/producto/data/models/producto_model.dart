import 'foto_model.dart';

class Producto
{
  	final int? id;
  	String nombre;
  	String? descripcion;
  	String? codigo;
  	String? fechaRegistro;
  	List<ProductoFoto> fotos; // Ahora estructurado usando nuestro nuevo foto_model.dart

  	Producto({
    	this.id,
    	required this.nombre,
        this.codigo = '',
    	this.descripcion = '',
    	this.fotos = const [],
    	this.fechaRegistro
  	});

  	Map<String, dynamic> toMap()
	{
		return {
    	  	'id': id,
    	  	'codigo': codigo,
    	  	'nombre': nombre,
    	  	'descripcion': descripcion,
    	  	'fecha_registro': fechaRegistro,
    	};
  	}

  	factory Producto.fromMap(Map<String, dynamic> map, { List<ProductoFoto> fotos = const [] })
	{
    	return Producto(
      		id: map['id'],
      		codigo: map['codigo'],
      		nombre: map['nombre'],
      		descripcion: map['descripcion'],
      		fechaRegistro: map['fecha_registro'],
      		fotos: fotos,
    	);
  	}
}