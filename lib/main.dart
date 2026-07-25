import 'package:flutter/material.dart';
import 'package:graei/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:graei/core/config/app_settings_loader.dart';

// Importación del DI centralizado
import 'core/di/injection_container.dart' as di;

// Importaciones de presentación
import 'package:graei/features/producto/presentation/providers/producto_provider.dart';
import 'package:graei/features/producto/presentation/screens/producto_buscador_screen.dart';


void main() async
{
    WidgetsFlutterBinding.ensureInitialized();
    await AppSettingsLoader.load();
  
    // 1. Inicializa de golpe todas tus dependencias (incluyendo la base de datos asíncrona)
    await di.configureDependencies(); 

    runApp(
        MultiProvider(
            providers: [
                
                // 2. Resolvemos el Provider directamente desde el Service Locator (sl) de forma transparente
                ChangeNotifierProvider(
                    create: (_) => di.getIt<ProductoProvider>(),
                ),
            ],
            child: const MyApp(),
        ),
    );
}

class MyApp extends StatelessWidget
{  
    const MyApp({super.key});

    @override
    Widget build(BuildContext context)
    {
        return MaterialApp(
            title: 'GRAEI ERP',
            debugShowCheckedModeBanner: false,

            themeMode: ThemeMode.system,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            home: const ProductoBuscadorScreen(),
        );
    }
}