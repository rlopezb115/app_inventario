#!/bin/bash
mkdir -p libr
> libr/consolidado.dart

find lib -type f -name "*.dart" | sort | while read -r file; do
    echo "// ========================================================" >> libr/consolidado.dart
    echo "// ARCHIVO: $file" >> libr/consolidado.dart
    echo "// ========================================================" >> libr/consolidado.dart
    cat "$file" >> libr/consolidado.dart
    echo -e "\n\n" >> libr/consolidado.dart
done

echo "¡Consolidación terminada! Archivo generado en libr/consolidado.dart"
