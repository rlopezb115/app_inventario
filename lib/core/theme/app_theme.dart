import 'package:flutter/material.dart';

class AppTheme
{
    // Evitamos que la clase sea instanciada accidentalmente
    AppTheme._();

    // --- TEMA CLARO ---
    static ThemeData get lightTheme
    {
        return ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),

            colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                surfaceContainer: Color(0xFFEDF4FC),
                onSurfaceVariant: Color(0xFF424242),
            ),
      
            // Centralización estética para todos los Inputs en modo Claro
            inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                prefixIconColor: Colors.grey[600],
                suffixIconColor: Colors.grey[600],
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
            ),
        );
    }

    // --- TEMA OSCURO ---
    static ThemeData get darkTheme
    {
        return ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primaryColor: Colors.redAccent,
            scaffoldBackgroundColor: const Color(0xFF121212), // Fondo oscuro estándar

            colorScheme: ColorScheme.dark(
                primary: Colors.redAccent,
                surfaceContainer: const Color(0xFF1E292B),
                surfaceContainerHighest: Colors.grey[900]!,
                onSurfaceVariant: Color(0xFFE0E0E0),
            ),
            
            cardTheme: CardThemeData(
                elevation: 0,
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: Colors.grey[800]!,
                        width: 1.2,
                    ),
                ),
            ),
      
            // Centralización estética para todos los Inputs en modo Oscuro
            inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFF1E1E1E), // Fondo del input ligeramente más claro que el scaffold
                prefixIconColor: Colors.grey[400],
                suffixIconColor: Colors.grey[400],
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                ),
            ),
        );
    }
}