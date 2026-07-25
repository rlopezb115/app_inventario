abstract class AppSettings
{
    static late final String nameDbSqlite;
    static late final String nameDbIsar;
    
    static void initialize(Map<String, dynamic> json)
    {
        nameDbSqlite = json['name_db_sqlite'] ?? '';
        nameDbIsar = json['name_db_isar'] ?? '';
    }
}