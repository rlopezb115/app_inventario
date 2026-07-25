import 'package:graei/core/extensions/numero_extension.dart';
import 'package:graei/core/utils/generador_codigo.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import 'package:graei/core/atomic_process/atomic_session.dart';
import 'package:graei/core/database/database_helper.dart';
import 'package:graei/features/producto/data/models/foto_model.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';

@lazySingleton
class ProductoLocalDataSource
{
  	final DatabaseHelper dbHelper;
  	ProductoLocalDataSource({required this.dbHelper});

  	Future<List<Producto>> obtenerProductosPaginados(int limit, int offset) async
	{
    	final db = await dbHelper.database;
    
		// Consulta paginada de productos
    	final List<Map<String, dynamic>> resProductos = await db.query(
      		'producto',
      		limit: limit,
      		offset: offset,
      		orderBy: 'fecha_registro DESC',
    	);

    	List<Producto> listaProductos = [];
    	for (var prodMap in resProductos)
		{
      		final producto = Producto.fromMap(prodMap);
      		final List<Map<String, dynamic>> resFotos = await db.query(
        		'producto_foto',
        		where: 'producto_id = ?',
        		whereArgs: [producto.id],
      		);
      
      		producto.fotos = resFotos.map((f) => ProductoFoto.fromMap(f)).toList();
      		listaProductos.add(producto);
    	}
    
		return listaProductos;
  	}

    Future<Producto?> obtenereProducto(int id, { AtomicSession? atomicSession }) async
	{
        if (!id.esMayorACero) return null;
        final DatabaseExecutor executor = atomicSession != null
                                      ? atomicSession.session
                                      : await dbHelper.database;

    	final List<Map<String, dynamic>> resProducto = await executor.query(
            'producto', 
            where: 'id = ?', 
            whereArgs: [id],
            limit: 1
        );

        if (resProducto.isEmpty) return null;
        return Producto.fromMap(resProducto.first);
  	}

  	Future<List<Producto>> buscarProductos(String query, int limit, int offset) async
	{
    	final db = await dbHelper.database;
    	final String likeQuery = '%$query%';

    	// Búsqueda usando LIKE en código y nombre[cite: 3]
    	final List<Map<String, dynamic>> resProductos = await db.query(
      		'producto',
      		where: 'codigo LIKE ? OR nombre LIKE ?',
      		whereArgs: [likeQuery, likeQuery],
      		limit: limit,
      		offset: offset,
    	);

    	List<Producto> listaProductos = [];
    	for (var prodMap in resProductos)
		{
      		final producto = Producto.fromMap(prodMap);
      		final List<Map<String, dynamic>> resFotos = await db.query(
        		'producto_foto',
        		where: 'producto_id = ?',
        		whereArgs: [producto.id],
      		);
      
	  		producto.fotos = resFotos.map((f) => ProductoFoto.fromMap(f)).toList();
      		listaProductos.add(producto);
    	}
    	
		return listaProductos;
  	}
    
  	Future<int> registrarProductoTransaccional(Producto producto, { AtomicSession? atomicSession  }) async
	{
    	final DatabaseExecutor executor = atomicSession != null
                                          ? atomicSession.session
                                          : await dbHelper.database;

        producto.codigo = GeneradorCodigo.alfanumerico();
        producto.fechaRegistro = DateTime.now().toIso8601String();
        final int productoId = await executor.insert('producto', producto.toMap());
        return productoId;
  	}

    Future<bool> actualizarProductoTransaccional(Producto producto, { AtomicSession? atomicSession }) async
    {
        if (!producto.id.esMayorACero) return false;

        int filasAfectadas = 0;
        final productoActual = await obtenereProducto(producto.id!, atomicSession: atomicSession);
        if (productoActual != null)
        {
            final DatabaseExecutor executor = atomicSession != null
                                            ? atomicSession.session
                                            : await dbHelper.database;

            productoActual.nombre = producto.nombre;
            productoActual.descripcion = producto.descripcion;

            filasAfectadas = await executor.update(
                'producto',
                productoActual.toMap(),
                where: 'id = ?',
                whereArgs: [producto.id]
            );

        }


        return filasAfectadas.esMayorACero;
    }

  	Future<void> eliminarProducto(int id, { AtomicSession? atomicSession }) async
	{
        final DatabaseExecutor executor = atomicSession != null 
                                          ? atomicSession.session
                                          : await dbHelper.database;

    	await executor.delete(
            'producto', 
            where: 'id = ?', 
            whereArgs: [id]
        );
  	}
}