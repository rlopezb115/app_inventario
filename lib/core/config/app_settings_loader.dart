import 'dart:convert';
import 'package:flutter/services.dart';
import 'app_settings.dart';

abstract class AppSettingsLoader
{
    static const String _configPath = 'assets/config/app_settings.json';

    static Future<void> load() async
    {
        try
        {
            final String jsonString = await rootBundle.loadString(_configPath);
            final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
            AppSettings.initialize(jsonMap);
        }
        catch (e)
        {
            print('Error crítico al procesar el archivo de configuración: $e');
            AppSettings.initialize({});
        }
    }
}