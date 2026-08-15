import 'package:injectable/injectable.dart';

import 'package:graei/core/atomic_process/atomic_process_manager.dart';
import 'package:graei/core/database/sqflite_atomic_process_manager.dart';
import 'package:graei/core/database/database_helper.dart';
import 'package:graei/core/di/injection_names.dart';

@module
abstract class AppModule {

    @Named(InjectionNames.dbAtomic)
    @LazySingleton()
    AtomicProcessManager sqliteAtomicProcessManager(DatabaseHelper dbHelper)
    {
        return SqfliteAtomicProcessManager(dbHelper: dbHelper);
    }
    
}