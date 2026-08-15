import 'foto_model.dart';

class Producto
{
  	final int? id;
  	final String nombre;
  	final String? descripcion;
  	final String? codigo;
  	final String? fechaRegistro;
  	final List<ProductoFoto>? fotos;

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

    Producto copyWith({
        int? id,
        String? nombre,
        String? descripcion,
        String? codigo,
        String? fechaRegistro,
        List<ProductoFoto>? fotos,
    }) {
        return Producto(
            id: id ?? this.id,
            nombre: nombre ?? this.nombre,
            descripcion: descripcion ?? this.descripcion,
            codigo: codigo ?? this.codigo,
            fechaRegistro: fechaRegistro ?? this.fechaRegistro,
            fotos: fotos ?? this.fotos,
        );
    }
}