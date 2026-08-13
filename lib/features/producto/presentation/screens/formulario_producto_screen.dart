// ========================================================
// ARCHIVO: lib/features/producto/presentation/screens/formulario_producto_screen.dart
// ========================================================
import 'package:flutter/material.dart';
import 'package:graei/core/utils/validaciones.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graei/core/services/image_picker_service.dart';
import 'package:graei/features/producto/data/models/foto_model.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';
import 'package:graei/features/producto/presentation/providers/producto_provider.dart';
import 'package:graei/features/producto/presentation/widgets/foto_carrete.dart';

class FormularioProductoScreen extends StatefulWidget
{
    final Producto? producto;

    const FormularioProductoScreen({
        super.key,
        this.producto
    });

    @override
    State<FormularioProductoScreen> createState() => _FormularioProductoScreenState();
}

class _FormularioProductoScreenState extends State<FormularioProductoScreen>
{
    final _formKey = GlobalKey<FormState>();
    final _nombreController = TextEditingController();
    final _descripcionController = TextEditingController();
    
    final _imagePickerService = ImagePickerService();
    
    final List<String> _rutasFotosSeleccionadas = [];
    final List<String> _fotosEliminadasEnEdicion = [];
    bool get _esEdicion => widget.producto != null;

    @override
    void initState()
    {
        super.initState();
        _inicializarDatosFormulario();
    }

    void _inicializarDatosFormulario()
    {
        if (_esEdicion)
        {
            _nombreController.text = widget.producto!.nombre;
            _descripcionController.text = widget.producto!.descripcion ?? '';

            _rutasFotosSeleccionadas.addAll(
                widget.producto!.fotos.map((foto) => foto.rutaFoto)
            );
        }
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(title: Text(_esEdicion ? 'Editar Producto' : 'Registrar Producto')),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        children: [
                            FotoCarrete(
                                rutas: _rutasFotosSeleccionadas,
                                onAdd: _agregarFoto,
                                onDelete: _removerFotoSeleccionada,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                                controller: _nombreController,
                                decoration: const InputDecoration(labelText: 'Nombre del Producto *'),
                                validator: _validarNombreProducto
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                                controller: _descripcionController,
                                decoration: const InputDecoration(labelText: 'Descripción (Opcional)'),
                                maxLines: 3,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                                onPressed: _guardar,
                                child: Text(_esEdicion ? 'Actualizar Producto' : 'Guardar Producto'),
                            )
                        ],
                    ),
                ),
            ),
        );
    }

    String? _validarNombreProducto(String? valor)
    {
        return Validaciones.campoRequerido(valor, 'El nombre del producto es requerido.');
    }

    void _removerFotoSeleccionada(int indice)
    {
        final rutaRemovida = _rutasFotosSeleccionadas[indice];
        setState(()
        {
            _rutasFotosSeleccionadas.removeAt(indice);
            _fotosEliminadasEnEdicion.add(rutaRemovida);
        });
    }

    void _agregarFoto()
    {
        showModalBottomSheet(
            context: context,
            builder: (ctx) => SafeArea(
                child: Wrap(
                    children: [
                        ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Galería'),
                            onTap: _agregarFotoGaleria,
                        ),
                        ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Cámara'),
                            onTap: _agregarFotoCamara,
                        ),
                    ],
                ),
            ),
        );
    }

    void _agregarFotoGaleria()
    {
        _seleccionarFoto(ImageSource.gallery);
        Navigator.pop(context);
    }

    void _agregarFotoCamara()
    {
        _seleccionarFoto(ImageSource.camera);
        Navigator.pop(context);
    }

    Future<void> _seleccionarFoto(ImageSource source) async
    {
        if (_rutasFotosSeleccionadas.length >= 5)
        {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Se ha alcanzado el límite máximo de 5 fotografías')),
            );
            return;
        }

        final String? rutaProcesada = await _imagePickerService.capturarYProcesarImagen(
            source: source,
            index: _rutasFotosSeleccionadas.length,
        );

        if (rutaProcesada != null && mounted)
        {
            setState(() {
                _rutasFotosSeleccionadas.add(rutaProcesada);
            });
        }
    }

    Future<void> _guardar() async
    {
        if (_formKey.currentState!.validate())
        {
            final fotosModel = _rutasFotosSeleccionadas.map<ProductoFoto>((ruta) => ProductoFoto(
                rutaFoto: ruta,
                productoId: widget.producto?.id
            )).toList();

            final producto = Producto(
                id: widget.producto?.id,
                codigo: widget.producto?.codigo,
                nombre: _nombreController.text,
                descripcion: _descripcionController.text,
                fotos: fotosModel,
            );

            bool guardadoExitoso = false;

            if (_esEdicion)
            {
                guardadoExitoso = await context.read<ProductoProvider>().actualizarProducto(
                    producto,
                    _rutasFotosSeleccionadas,
                    _fotosEliminadasEnEdicion,
                );
            }
            else
            {
                guardadoExitoso = await context.read<ProductoProvider>().registrarNuevoProducto(
                    producto,
                    _rutasFotosSeleccionadas,
                );
            }
            
            if (guardadoExitoso && mounted) 
            {
                Navigator.pop(context);
            }
        }
    }

    @override
    void dispose()
    {
        _nombreController.dispose();
        _descripcionController.dispose();
        super.dispose();
    }
}