import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graei/core/widgets/boton_circular.dart';
import 'package:graei/features/producto/data/models/producto_model.dart';

class ProductoCard extends StatelessWidget
{
    final Producto _producto;
    final VoidCallback _onDelete;
    final VoidCallback _onEdit;

    const ProductoCard({
        super.key, 
        required this._producto, 
        required this._onDelete,
        required this._onEdit
    });

    @override
    Widget build(BuildContext context)
    {
        return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                // Miniatura de imagen
                                Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: _producto.fotos.isNotEmpty
                                    ?
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.file(File(_producto.fotos.first.rutaFoto), fit: BoxFit.cover),
                                        )
                                    : 
                                        const Center(
                                            child: Text(
                                                'No hay fotos disponibles', 
                                                style: TextStyle(fontSize: 10), 
                                                textAlign: TextAlign.center,
                                            ),
                                        ),
                                ),
                                
                                const SizedBox(width: 16),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text(
                                                _producto.codigo!,
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                                _producto.nombre, 
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            
                                            if (_producto.descripcion != null)
                                                Text(
                                                    _producto.descripcion!, 
                                                    maxLines: 2, 
                                                    overflow: TextOverflow.ellipsis, 
                                                    style: TextStyle(color: Colors.grey[600]),
                                                ),
                                        ],
                                    ),
                                ),
                            ],
                        ),
            
                        // Separador Visual
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(height: 1),
                        ),

                        // Fila de Botones de Acción Rápida (Fila Inferior - Ancho Completo)[cite: 3]
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                                BotonCircular(
                                    icon: Icons.add_shopping_cart,
                                    label: 'Comprar',
                                    onPressed: () {},
                                ),
                                BotonCircular(
                                    icon: Icons.monetization_on,
                                    label: 'Vender',
                                    onPressed: () {},
                                ),
                                BotonCircular(
                                    icon: Icons.edit,
                                    label: 'Editar',
                                    onPressed: _onEdit,
                                ),
                                BotonCircular(
                                    icon: Icons.delete,
                                    label: 'Eliminar',
                                    onPressed: _onDelete, // Callback que abre el diálogo[cite: 3]
                                ),
                            ],
                        ),
                    ],
                ),
            ),
        );
    }
}