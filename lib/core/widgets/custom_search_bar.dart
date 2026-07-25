import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget
{
    final TextEditingController controller;
    final String hintText;
    final ValueChanged<String> onChanged;
    final VoidCallback onClear;

    const CustomSearchBar({
        super.key,
        required this.controller,
        this.hintText = 'Buscar...',
        required this.onChanged,
        required this.onClear,
    });

    @override
    Widget build(BuildContext context)
    {
        return TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                        controller.clear();
                        onClear(); 
                    },
                ),
            ),
            onChanged: onChanged,
        );
    }
}