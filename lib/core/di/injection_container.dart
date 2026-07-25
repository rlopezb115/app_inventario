import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:graei/core/di/injection_container.config.dart';


final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // Nombre del método de inicialización autogenerado
  preferRelativeImports: true, // Prefiere importaciones relativas dentro del proyecto
  asExtension: true, // Permite llamarlo como getIt.init()
)
Future<void> configureDependencies() async
{
    getIt.init();
}