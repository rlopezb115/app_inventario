import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import 'package:graei/core/database/database_helper.dart';
import 'package:graei/core/atomic_process/atomic_process_manager.dart';
import 'package:graei/core/atomic_process/atomic_session.dart';
import 'package:graei/core/di/injection_names.dart';
import 'package:graei/core/exceptions/process_aborted_exception.dart';

class SqfliteAtomicSession implements AtomicSession
{
    final Transaction txn;
    SqfliteAtomicSession(this.txn);

    @override
    Transaction get session => txn;

    @override
    void abort(String reason)
    {
        // Lanzar esta excepción dentro de 'db.transaction' de sqflite
        // fuerza el ROLLBACK automático en la base de datos local.
        throw ProcessAbortedException(reason);
    }
}

@Named(InjectionNames.dbAtomic)
class SqfliteAtomicProcessManager implements AtomicProcessManager
{
    final DatabaseHelper dbHelper;

    SqfliteAtomicProcessManager({required this.dbHelper});

    @override
    Future<T> runInAtomicProcess<T>(Future<T> Function(AtomicSession session) action) async
    {
        final db = await dbHelper.database;
        
        return await db.transaction((txn) async
        {
            final session = SqfliteAtomicSession(txn);
            return await action(session);
        });
    }
}