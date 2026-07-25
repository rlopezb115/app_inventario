import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

@lazySingleton
class ImagePickerService
{
    final ImagePicker _picker = ImagePicker();

    /// Abre la cámara o galería, comprime la imagen y la guarda en el directorio privado.
    /// Retorna la ruta física final (String) o null si el usuario canceló.
    Future<String?> capturarYProcesarImagen({
        required ImageSource source,
        required int index,
    }) async {
    
        try
        {
            // 1. Seleccionar la imagen original
            final XFile? imagenOriginal = await _picker.pickImage(
                source: source,
                imageQuality: 100, // Calidad total inicial para luego comprimir controladamente
            );

            if (imagenOriginal == null) return null;

            // 2. Obtener el directorio privado de documentos del dispositivo
            final Directory directorioApp = await getApplicationDocumentsDirectory();
            final String rutaBase = directorioApp.path;

            // 3. Crear el nombre bajo la estructura prod_[timestamp]_[index].jpg
            final int timestamp = DateTime.now().millisecondsSinceEpoch;
            final String nuevaRuta = '$rutaBase/prod_${timestamp}_$index.jpg';

            // 4. Comprimir y guardar en el destino final usando flutter_image_compress
            final XFile? imagenComprimida = await FlutterImageCompress.compressAndGetFile(
                imagenOriginal.path,
                nuevaRuta,
                quality: 70, // Compresión interna óptima sin perder calidad comercial
                format: CompressFormat.jpeg,
            );

            if (imagenComprimida != null)
            {
                return imagenComprimida.path; // Retorna la ruta física final
            }
    
        }
        catch (e)
        {
            print('Error al procesar la imagen en ${runtimeType.toString()}: $e');
        }
    
        return null;
    }

    Future<void> eliminarArchivoFisico(String ruta) async
    {
        try
        {
            final file = File(ruta);
            if (await file.exists())
            {
                await file.delete();
                print('Archivo eliminado físicamente: $ruta');
            }
        }
        catch (e)
        {
            print('Error al eliminar el archivo físico en ${runtimeType.toString()}: $e');
        }
    }
}