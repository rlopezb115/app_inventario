abstract class MediaStorageRepository
{
    /// Captura, comprime y guarda la imagen en un directorio TEMPORAL (Caché).
    Future<String?> capturarImagenTemporal({required int index});

    /// Mueve una lista de imágenes de la caché temporal a la carpeta PERMANENTE de la app.
    /// Retorna las rutas finales permanentes.
    Future<List<String>> persistirImagenesTemporales(List<String> rutasTemporales);

    /// Elimina un archivo físico del almacenamiento.
    Future<void> eliminarArchivoFisico(String ruta);

    /// Elimina múltiples archivos físicos del disco.
    Future<void> eliminarArchivosFisicos(List<String> rutas);
}