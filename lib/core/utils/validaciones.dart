abstract class Validaciones
{
    /// Evalúa si una cadena es nula o vacía. Retorna [mensajeError] si falla.
    static String? campoRequerido(String? valor, String mensajeError)
    {
        if (valor == null || valor.trim().isEmpty)
        {
            return mensajeError;
        }
        
        return null;
    }
}