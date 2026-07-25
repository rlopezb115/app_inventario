import 'dart:io';
import 'package:flutter/material.dart';

class FotoCarrete extends StatelessWidget
{
    final List<String> rutas;
    final VoidCallback onAdd;
    final Function(int) onDelete;

    const FotoCarrete({
        super.key,
        required this.rutas,
        required this.onAdd,
        required this.onDelete,
    });

    @override
    Widget build(BuildContext context)
    {
        return SizedBox(
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: rutas.length + 1,
                itemBuilder: (context, index)
                {
                    if (index == rutas.length)
                    {
                        // Botón de agregar foto (solo visible si hay menos de 5 fotos)
                        return rutas.length < 5
                        ?
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: onAdd,
                                    child: Container(
                                        width: 84,
                                        height: 84,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey[400]!, style: BorderStyle.solid),
                                        ),
                                        child: const Icon(Icons.add_a_photo, color: Colors.grey),
                                    ),
                                ),
                            )
                        : 
                            const SizedBox.shrink();
                    }

                    final ruta = rutas[index];

                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                                Container(
                                    width: 84,
                                    height: 84,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                            image: FileImage(File(ruta)),
                                            fit: BoxFit.cover,
                                        ),
                                    ),
                                ),
                                
                                Positioned(
                                    top: -8,
                                    right: -8,
                                    child: GestureDetector(
                                        onTap: () => onDelete(index),
                                        child: const CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.red,
                                            child: Icon(Icons.close, size: 14, color: Colors.white),
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    );
                },
            ),
        );
    }
}