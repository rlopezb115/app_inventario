import 'package:flutter/material.dart';
import 'package:graei/core/widgets/dialogo_confirmacion.dart';
import 'package:graei/core/widgets/flexible_collection_view.dart';
import 'package:provider/provider.dart';
import 'package:graei/core/widgets/custom_search_bar.dart';
import 'package:graei/app_routes.dart';
import 'package:graei/core/widgets/drawer_menu.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';
import 'package:graei/features/producto/presentation/providers/producto_provider.dart';
import 'package:graei/features/producto/presentation/widgets/producto_card.dart';
import 'package:graei/features/producto/presentation/screens/formulario_producto_screen.dart';

class ProductoBuscadorScreen extends StatefulWidget
{
    const ProductoBuscadorScreen({super.key});

    @override
    State<ProductoBuscadorScreen> createState() => _ProductoBuscadorScreenState();
}

class _ProductoBuscadorScreenState extends State<ProductoBuscadorScreen>
{
    final ScrollController _scrollController = ScrollController();
    final TextEditingController _searchController = TextEditingController();
    
    @override
    void initState()
    {
        super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_)
        {
            context.read<ProductoProvider>().inicializarCatalogo();
        });
    
        _scrollController.addListener(_onScroll);
    }

    @override
    void dispose()
    {
        _scrollController.dispose();
        _searchController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(title: const Text('Producto Buscador')),
            drawer: DrawerMenu(
                options: AppRoutes.getDrawerOptions(context, 'producto_buscador'),
            ),
            body: Column(
                children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomSearchBar(
                            controller: _searchController,
                            hintText: 'Buscar por código o nombre...',
                            onChanged: _aplicarFiltroBusqueda,
                            onClear: _restablecerBusqueda,
                        ),
                    ),
          
                    Expanded(
                        child: Consumer<ProductoProvider>(
                            builder: _buildListadoProductos
                        ),
                    ),
                ],
            ),
      
            floatingActionButton: FloatingActionButton(
                onPressed:_crearNuevoProducto,
                child: const Icon(Icons.add),
            ),
        );
    }

    Widget _buildListadoProductos(
        BuildContext context,
        ProductoProvider provider,
        Widget? child,
    ) {
        
        if (provider.productos.isEmpty && !provider.isLoading)
        {
            return const Center(child: Text('No se encontraron productos.'));
        }

        return Stack(
            children: [
                FlexibleCollectionView(
                    items: provider.productos,
                    scrollController: _scrollController,
                    itemBuilder: _buildProductoCard,
                ),
            
                if (provider.isLoading)
                    const Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(child: CircularProgressIndicator()),
                    ),
            ],
        );
    }

    Widget _buildProductoCard(Producto producto)
    {
        return ProductoCard(
            producto: producto,
            onDelete: () => _mostrarConfirmarEliminacion(producto),
            onEdit: () => _editarProducto(producto)
        );
    }

    void _onScroll()
    {
        if (_scrollController.hasClients)
        {
            final maxScroll = _scrollController.position.maxScrollExtent;
            final currentScroll = _scrollController.position.pixels;
      
            if (currentScroll >= (maxScroll * 0.85))
            {
                // Disparador al 85% del scroll
                context.read<ProductoProvider>().cargarSiguienteBloque();
            }
        }
    }

    void _aplicarFiltroBusqueda(String val)
    {
        context.read<ProductoProvider>().cambiarFiltroBusqueda(val);
    }

    void _restablecerBusqueda()
    {
        context.read<ProductoProvider>().limpiarBusqueda();
    }

    Future<void> _crearNuevoProducto() async
    {
        _searchController.clear();

        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const FormularioProductoScreen(),
            ),
        );
    }

    void _editarProducto(Producto productoSeleccionado)
    {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FormularioProductoScreen(producto: productoSeleccionado),
            ),
        );
    }

    void _mostrarConfirmarEliminacion(Producto producto)
    {
        final theme = Theme.of(context);

        DialogoConfirmacion.mostrar(
            context,
            titulo: '¿Eliminar este producto?',
            textoConfirmar: 'Sí, eliminar',
            contenido: RichText(
                text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                    ),
                    children: [
                        const TextSpan(
                            text: 'Esta acción eliminará permanentemente el producto ',
                        ),
                        TextSpan(
                            text: '"${producto.nombre}"',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                            text: ' y todas sus fotos asociadas.\n\n¿Deseas continuar? Esta acción no se puede deshacer.',
                        ),
                    ],
                ),
            ),
            onConfirmar: () async => await _eliminarProducto(context, producto),
        );
    }

    Future<void> _eliminarProducto(
        BuildContext context, 
        Producto producto,
    ) async 
    {
        await context.read<ProductoProvider>().eliminarProducto(producto.id!);
        if (context.mounted)
        {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Producto eliminado con éxito.')),
            );
        }
    }
}