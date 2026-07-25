/// Token utilizado globalmente para señalizar la cancelación de cualquier 
/// operación asíncrona, pesada o transaccional en la aplicación.
class CancellationToken
{
    bool _isCancelled = false;
    String? _reason;

    bool get isCancelled => _isCancelled;
    String? get reason => _reason;

    /// Activa la señal de cancelación con un motivo opcional.
    void cancel([String reason = 'Operación cancelada.'])
    {
        _isCancelled = true;
        _reason = reason;
    }
}