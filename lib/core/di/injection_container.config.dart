// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/producto/data/datasources/foto_local_datasource.dart'
    as _i688;
import '../../features/producto/data/datasources/producto_local_datasource.dart'
    as _i966;
import '../../features/producto/data/repositories/foto_repository_impl.dart'
    as _i18;
import '../../features/producto/data/repositories/producto_repository_impl.dart'
    as _i469;
import '../../features/producto/domain/repositories/foto_repository.dart'
    as _i451;
import '../../features/producto/domain/repositories/producto_repository.dart'
    as _i398;
import '../../features/producto/domain/usecases/actualizar_producto.dart'
    as _i943;
import '../../features/producto/domain/usecases/buscar_productos.dart'
    as _i1001;
import '../../features/producto/domain/usecases/eliminar_producto.dart'
    as _i412;
import '../../features/producto/domain/usecases/obtener_productos_paginados.dart'
    as _i521;
import '../../features/producto/domain/usecases/registrar_producto.dart'
    as _i861;
import '../../features/producto/presentation/providers/producto_provider.dart'
    as _i778;
import '../atomic_process/atomic_process_manager.dart' as _i466;
import '../database/database_helper.dart' as _i64;
import '../services/image_picker_service.dart' as _i644;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i64.DatabaseHelper>(() => _i64.DatabaseHelper());
    gh.lazySingleton<_i644.ImagePickerService>(
      () => _i644.ImagePickerService(),
    );
    gh.lazySingleton<_i466.AtomicProcessManager>(
      () => appModule.sqliteAtomicProcessManager,
      instanceName: 'db',
    );
    gh.lazySingleton<_i688.FotoLocalDataSource>(
      () => _i688.FotoLocalDataSource(dbHelper: gh<_i64.DatabaseHelper>()),
    );
    gh.lazySingleton<_i966.ProductoLocalDataSource>(
      () => _i966.ProductoLocalDataSource(dbHelper: gh<_i64.DatabaseHelper>()),
    );
    gh.lazySingleton<_i451.FotoRepository>(
      () => _i18.FotoRepositoryImpl(
        localDataSource: gh<_i688.FotoLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i398.ProductoRepository>(
      () => _i469.ProductoRepositoryImpl(
        localDataSource: gh<_i966.ProductoLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i412.EliminarProducto>(
      () => _i412.EliminarProducto(
        productoRepository: gh<_i398.ProductoRepository>(),
        fotoRepository: gh<_i451.FotoRepository>(),
        imagePickerService: gh<_i644.ImagePickerService>(),
        atomicProcessManager: gh<_i466.AtomicProcessManager>(
          instanceName: 'db',
        ),
      ),
    );
    gh.lazySingleton<_i943.ActualizarProducto>(
      () => _i943.ActualizarProducto(
        productoRepository: gh<_i398.ProductoRepository>(),
        fotoRepository: gh<_i451.FotoRepository>(),
        atomicProcessManager: gh<_i466.AtomicProcessManager>(
          instanceName: 'db',
        ),
      ),
    );
    gh.lazySingleton<_i861.RegistrarProducto>(
      () => _i861.RegistrarProducto(
        productoRepository: gh<_i398.ProductoRepository>(),
        fotoRepository: gh<_i451.FotoRepository>(),
        atomicProcessManager: gh<_i466.AtomicProcessManager>(
          instanceName: 'db',
        ),
      ),
    );
    gh.lazySingleton<_i1001.BuscarProductos>(
      () => _i1001.BuscarProductos(gh<_i398.ProductoRepository>()),
    );
    gh.lazySingleton<_i521.ObtenerProductosPaginados>(
      () => _i521.ObtenerProductosPaginados(gh<_i398.ProductoRepository>()),
    );
    gh.factory<_i778.ProductoProvider>(
      () => _i778.ProductoProvider(
        obtenerProductosPaginadosUC: gh<_i521.ObtenerProductosPaginados>(),
        buscarProductosUC: gh<_i1001.BuscarProductos>(),
        registrarProductoUC: gh<_i861.RegistrarProducto>(),
        actualizarProductoUC: gh<_i943.ActualizarProducto>(),
        eliminarProductoUC: gh<_i412.EliminarProducto>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
