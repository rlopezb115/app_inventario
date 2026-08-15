/// Excepción global lanzada cuando un proceso atómico es interrumpido 
/// o abortado de manera segura antes de completarse.
class ProcessAbortedException implements Exception
{
    final String _message;
    ProcessAbortedException(this._message);
    
    @override
    String toString() => 'ProcessAbortedException: $_message';
}