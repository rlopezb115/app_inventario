import 'dart:math';

abstract class GeneradorCodigo
{
    GeneradorCodigo._();

    static final Random _random = Random();
    static const String _caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    /// Genera un código alfanumérico aleatorio de la [longitud] especificada.
    static String alfanumerico({int longitud = 12})
    {
        return List.generate(
            longitud, 
            (_) => _caracteres[_random.nextInt(_caracteres.length)],
        ).join();
    }
}