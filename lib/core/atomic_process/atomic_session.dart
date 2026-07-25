/// Representa de forma abstracta la sesión activa de un proceso atómico.
/// Mantiene el contexto de las operaciones encadenadas en curso.
abstract class AtomicSession
{
    /// Retorna la conexión o el manejador físico real de la sesión 
    /// (por ejemplo, el objeto [Transaction] de sqflite o un FileSystem handler).
    dynamic get session;

    /// Aborta de forma segura e inmediata la sesión en curso, revirtiendo
    /// todos los cambios realizados hasta el momento en este proceso.
    void abort(String reason);
}