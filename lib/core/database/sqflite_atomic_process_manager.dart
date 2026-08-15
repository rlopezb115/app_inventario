import 'package:sqflite/sqflite.dart';

import 'package:graei/core/database/database_helper.dart';
import 'package:graei/core/atomic_process/atomic_process_manager.dart';
import 'package:graei/core/atomic_process/atomic_session.dart';
import 'package:graei/core/exceptions/process_aborted_exception.dart';

class SqfliteAtomicSession implements AtomicSession
{
    final Transaction _txn;
    SqfliteAtomicSession(this._txn);

    @override
    Transaction get session => _txn;

    @override
    void abort(String reason)
    {
        // Lanzar esta excepción dentro de 'db.transaction' de sqflite
        // fuerza el ROLLBACK automático en la base de datos local.
        throw ProcessAbortedException(reason);
    }
}

class SqfliteAtomicProcessManager implements AtomicProcessManager
{
    final DatabaseHelper _dbHelper;

    SqfliteAtomicProcessManager({required this._dbHelper});

    @override
    Future<T> runInAtomicProcess<T>(Future<T> Function(AtomicSession session) action) async
    {
        final db = await _dbHelper.database;
        
        return await db.transaction((txn) async
        {
            final session = SqfliteAtomicSession(txn);
            return await action(session);
        });
    }
}