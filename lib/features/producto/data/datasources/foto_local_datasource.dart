import 'package:injectable/injectable.dart';

import 'package:graei/core/atomic_process/atomic_session.dart';
import 'package:graei/core/database/database_helper.dart';
import 'package:graei/features/producto/data/models/foto_model.dart';

@lazySingleton
class FotoLocalDataSource
{
    final DatabaseHelper _dbHelper;

    FotoLocalDataSource({required this._dbHelper});

    Future<List<ProductoFoto>> obtenerRutasFotosPorProductoRangoId({
        required List<int> productosId
    }) async {

        final db = await _dbHelper.database;
        final String placeholders = List.filled(productosId.length, '?').join(',');
        final List<Map<String, dynamic>> resFotos = await db.query(
            'producto_foto',
            where: 'producto_id IN ($placeholders)',
            whereArgs: productosId,
        );

        final List<ProductoFoto> fotos = [];
        for (var fotoMap in resFotos)
        {
            final foto = ProductoFoto.fromMap(fotoMap);
            fotos.add(foto);
        }

        return fotos;
    }
    
    Future<List<String>> obtenerRutasFotosPorProductoId(int productoId) async
    {
        final db = await _dbHelper.database;

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
        final executor = atomicSession?.session ?? await _dbHelper.database;
        for (ProductoFoto foto in fotos)
        {
            final nuevaFoto = foto.copyWith(id: ++id, productoId: productoId).toMap();
            await executor.insert('producto_foto', nuevaFoto);
        }
    }

    /// Elimina los registros de fotos vinculados a un producto.
    /// Si se le provee una [atomicSession], la operación se une de forma atómica a ella.
    Future<void> eliminarFotosPorProductoId(int productoId, {AtomicSession? atomicSession}) async
    {
        final executor = atomicSession?.session ?? await _dbHelper.database;
        await executor.delete(
            'producto_foto',
            where: 'producto_id = ?',
            whereArgs: [productoId],
        );
    }
}