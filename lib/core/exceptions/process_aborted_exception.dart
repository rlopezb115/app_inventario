/// Excepción global lanzada cuando un proceso atómico es interrumpido 
/// o abortado de manera segura antes de completarse.
class ProcessAbortedException implements Exception
{
    final String message;
    ProcessAbortedException(this.message);
    
    @override
    String toString() => 'ProcessAbortedException: $message';
}