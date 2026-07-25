extension NumeroExtension on num?
{
    /// Retorna 'true', si es igual a null.
    bool get esNulo => this == null;

    /// Retorna 'true', si es diferente de null.
    bool get esDiferenteDeNulo => this != null;

    /// Retorna 'true', si es diferente de null y mayor a cero.
    bool get esMayorACero => this != null && this! > 0;
}