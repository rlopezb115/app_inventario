import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import 'package:graei/core/atomic_process/atomic_session.dart';
import 'package:graei/core/database/database_helper.dart';
import 'package:graei/features/producto/data/models/foto_model.dart';

@lazySingleton
class FotoLocalDataSource
{
    final DatabaseHelper dbHelper;

    FotoLocalDataSource({required this.dbHelper});
    
    Future<List<String>> obtenerRutasFotosPorProductoId(int productoId) async
    {
        final db = await dbHelper.database;

        final List<Map<String, dynamic>> resFotos = await db.query(
            'producto_foto',
            columns: ['ruta_foto'],
            where: 'producto_id = ?',
            whereArgs: [productoId],
        );

        return resFotos.map((f) => f['ruta_foto'] as String).toList();
    }

    Future<void> registrarFotosPorProductoId(int productoId, List<ProductoFoto> fotos, {AtomicSession? atomicSession}) async
    {
        int id = 0;
        final DatabaseExecutor executor = atomicSession != null 
                                          ? atomicSession.session as Transaction 
                                          : await dbHelper.database;

        for (ProductoFoto foto in fotos)
        {
            foto.id = ++id;
            foto.productoId = productoId;
            await executor.insert('producto_foto', foto.toMap());
        }
    }

    /// Elimina los registros de fotos vinculados a un producto.
    /// Si se le provee una [atomicSession], la operación se une de forma atómica a ella.
    Future<void> eliminarFotosPorProductoId(int productoId, {AtomicSession? atomicSession}) async
    {
        final DatabaseExecutor executor = atomicSession != null 
                                          ? atomicSession.session as Transaction 
                                          : await dbHelper.database;

        await executor.delete(
            'producto_foto',
            where: 'producto_id = ?',
            whereArgs: [productoId],
        );
    }
}