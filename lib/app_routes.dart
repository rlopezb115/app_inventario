import 'package:flutter/material.dart';
import 'package:graei/core/widgets/drawer_menu.dart';
import 'package:graei/features/producto/presentation/screens/producto_buscador_screen.dart';

class AppRoutes
{
    /// Lista centralizada de opciones de navegación para toda la app.
    /// Nuevas features se agregan aquí.
    static List<DrawerOption> getDrawerOptions(BuildContext context, String rutaActiva)
    {
        return [
            DrawerOption(
                icon: Icons.inventory_2,
                title: 'Producto',
                targetScreen: const SizedBox(), // Reemplazar por su respectiva vista
                isSelected: rutaActiva == 'producto_home',
            ),
            DrawerOption(
                icon: Icons.search_sharp,
                title: 'Producto Buscador',
                targetScreen: const ProductoBuscadorScreen(),
                isSelected: rutaActiva == 'producto_buscador',
            ),
            DrawerOption(
                icon: Icons.shopping_cart,
                title: 'Precio Compra',
                targetScreen: const SizedBox(),
                isSelected: rutaActiva == 'precio_compra',
            ),
            DrawerOption(
                icon: Icons.monetization_on,
                title: 'Precio Venta',
                targetScreen: const SizedBox(),
                isSelected: rutaActiva == 'precio_venta',
            ),
            DrawerOption(
                icon: Icons.people,
                title: 'Proveedor',
                targetScreen: const SizedBox(),
                isSelected: rutaActiva == 'proveedor',
            ),
        ];
    }
}