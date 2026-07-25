import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:graei/core/di/injection_names.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import 'package:graei/features/producto/domain/repositories/media_storage_repository.dart';

@LazySingleton(as: MediaStorageRepository)
@Named(InjectionNames.mediaStorageLocal)
class MediaStorageLocalRepositoryImpl implements MediaStorageRepository
{
    final ImagePicker _picker = ImagePicker();

    @override
    Future<String?> capturarImagenTemporal({required int index}) async
    {
        try
        {
            final XFile? imagenOriginal = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 100,
            );

            if (imagenOriginal == null) return null;

            // Guardamos la foto comprimida en el directorio TEMPORAL (Caché)
            final Directory tempDir = await getTemporaryDirectory();
            final int timestamp = DateTime.now().millisecondsSinceEpoch;
            final String rutaTemp = '${tempDir.path}/temp_prod_${timestamp}_$index.jpg';

            final XFile? imagenComprimida = await FlutterImageCompress.compressAndGetFile(
                imagenOriginal.path,
                rutaTemp,
                quality: 70,
                format: CompressFormat.jpeg,
            );

            return imagenComprimida?.path;
        }
        catch (_)
        {
            return null;
        }
    }

    @override
    Future<List<String>> persistirImagenesTemporales(List<String> rutasTemporales) async
    {
        final List<String> rutasPermanentes = [];
        final Directory docDir = await getApplicationDocumentsDirectory();

        for (int i = 0; i < rutasTemporales.length; i++)
        {
            final String ruta = rutasTemporales[i];

            // Si la foto ya está en el almacenamiento permanente (es una foto antigua en modo Edición)
            if (!ruta.contains('temp_prod_'))
            {
                rutasPermanentes.add(ruta);
                continue;
            }

            // Si es una foto temporal nueva, la movemos a la carpeta permanente de documentos
            final int timestamp = DateTime.now().millisecondsSinceEpoch;
            final String nuevaRutaPermanente = '${docDir.path}/prod_${timestamp}_$i.jpg';
            final File archivoTemp = File(ruta);
            if (await archivoTemp.exists())
            {
                final File archivoPersistido = await archivoTemp.copy(nuevaRutaPermanente);
                await archivoTemp.delete(); // Limpiamos la caché
                rutasPermanentes.add(archivoPersistido.path);
            }
        }

        return rutasPermanentes;
    }

    @override
    Future<void> eliminarArchivoFisico(String ruta) async
    {
        try
        {
            final file = File(ruta);
            if (await file.exists())
            {
                await file.delete();
            }
        }
        catch (_)
        {

        }
    }

    @override
    Future<void> eliminarArchivosFisicos(List<String> rutas) async
    {
        for (final ruta in rutas)
        {
            await eliminarArchivoFisico(ruta);
        }
    }
}