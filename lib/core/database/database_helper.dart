import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

@lazySingleton
class DatabaseHelper
{
  	DatabaseHelper();
	
    Database? _database;
	
    Future<Database> get database async
	{
		if (_database != null) return _database!;
		_database = await _initDatabase();
		return _database!;
	}
	
	Future<Database> _initDatabase() async
	{
		final dbPath = await getDatabasesPath();
		final path = join(dbPath, 'inventario.db');
		return await openDatabase(
      		path,
      		version: 1,
      		onCreate: _onCreate,
      		onConfigure: _onConfigure,
		);
  	}
	
	// Habilita claves foráneas para la eliminación en cascada de fotos[cite: 3]
  	Future<void> _onConfigure(Database db) async
	{
    	await db.execute('PRAGMA foreign_keys = ON');
  	}

  	Future<void> _onCreate(Database db, int version) async
	{
    	// Tabla Producto[cite: 3]
    	await db.execute('''
      		CREATE TABLE producto (
        		id INTEGER PRIMARY KEY AUTOINCREMENT,
        		codigo TEXT NOT NULL UNIQUE,
        		nombre TEXT NOT NULL UNIQUE,
        		descripcion TEXT,
        		fecha_registro TEXT NOT NULL
			)
		''');

    	// Tabla Fotos (Relación 1:N con borrado en cascada)[cite: 3]
    	await db.execute('''
      		CREATE TABLE producto_foto (
                id INTEGER NOT NULL,
                producto_id INTEGER NOT NULL,
                ruta_foto TEXT NOT NULL,
                PRIMARY KEY (id, producto_id),
                FOREIGN KEY (producto_id) REFERENCES producto (id)
            )
    	''');

    	// Índice compuesto para acelerar búsquedas instantáneas en SQLite[cite: 3]
    	await db.execute('''
      		CREATE INDEX idx_producto_busqueda ON producto(codigo, nombre)
    	''');
  	}
}