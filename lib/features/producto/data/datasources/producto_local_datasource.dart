import 'package:graei/core/extensions/numero_extension.dart';
import 'package:graei/core/utils/generador_codigo.dart';
import 'package:injectable/injectable.dart';

import 'package:graei/core/atomic_process/atomic_session.dart';
import 'package:graei/core/database/database_helper.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';

@lazySingleton
class ProductoLocalDataSource
{
  	final DatabaseHelper _dbHelper;
  	ProductoLocalDataSource({required this._dbHelper});

  	Future<List<Producto>> obtenerProductosPaginados(int limit, int offset) async
	{
    	final db = await _dbHelper.database;
    
		// Consulta paginada de productos
    	final List<Map<String, dynamic>> resProductos = await db.query(
      		'producto',
      		limit: limit,
      		offset: offset,
      		orderBy: 'fecha_registro DESC',
    	);

    	return resProductos.map((map) => Producto.fromMap(map)).toList();
  	}

    Future<Producto?> obtenerProducto(int id, { AtomicSession? atomicSession }) async
	{
        if (!id.esMayorACero) return null;
        final executor = atomicSession?.session ?? await _dbHelper.database;
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
    	final db = await _dbHelper.database;
    	final String likeQuery = '%$query%';
    	final List<Map<String, dynamic>> resProductos = await db.query(
      		'producto',
      		where: 'codigo LIKE ? OR nombre LIKE ?',
      		whereArgs: [likeQuery, likeQuery],
      		limit: limit,
      		offset: offset,
    	);

    	return resProductos.map((map) => Producto.fromMap(map)).toList();
  	}
    
  	Future<int> registrarProductoTransaccional(Producto producto, { AtomicSession? atomicSession  }) async
	{
    	final executor = atomicSession?.session ?? await _dbHelper.database;

        producto = producto.copyWith(
            codigo: GeneradorCodigo.alfanumerico(),
            fechaRegistro: DateTime.now().toUtc().toIso8601String()
        );
        
        final int productoId = await executor.insert('producto', producto.toMap());
        return productoId;
  	}

    Future<bool> actualizarProductoTransaccional(Producto producto, { AtomicSession? atomicSession }) async
    {
        if (!producto.id.esMayorACero) return false;

        int filasAfectadas = 0;
        Producto? productoActual = await obtenerProducto(producto.id!, atomicSession: atomicSession);
        if (productoActual != null)
        {
            final executor = atomicSession?.session ?? await _dbHelper.database;
            productoActual = productoActual.copyWith(
                nombre: producto.nombre,
                descripcion: producto.descripcion,
            );

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
        final executor = atomicSession?.session ?? await _dbHelper.database;
    	await executor.delete(
            'producto', 
            where: 'id = ?', 
            whereArgs: [id]
        );
  	}
}