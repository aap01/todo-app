// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:uuid/uuid.dart' as _i706;

import '../feature/todo/data/datasource/todo_local_data_source.dart' as _i494;
import '../feature/todo/data/datasource/todo_local_data_source_impl.dart'
    as _i1027;
import '../feature/todo/data/datasource/todo_remote_data_source.dart' as _i47;
import '../feature/todo/data/datasource/todo_remote_data_source_impl.dart'
    as _i592;
import '../feature/todo/data/di/todo_hive_module.dart' as _i657;
import '../feature/todo/data/model/todo_hive_model.dart' as _i345;
import '../feature/todo/data/repository/todo_repository_impl.dart' as _i491;
import '../feature/todo/domain/repository/todo_repository.dart' as _i953;
import '../feature/todo/domain/usecase/add_todo_usecase.dart' as _i273;
import '../feature/todo/domain/usecase/delete_todo_usecase.dart' as _i306;
import '../feature/todo/domain/usecase/get_all_todo_usecase.dart' as _i422;
import '../feature/todo/domain/usecase/update_todo_usecase.dart' as _i489;
import '../feature/todo/presentation/todo_bloc.dart' as _i896;
import '../feature/user_settings/data/datasource/user_settings_local_datasource.dart'
    as _i228;
import '../feature/user_settings/data/datasource/user_settings_local_datasource_impl.dart'
    as _i147;
import '../feature/user_settings/data/datasource/user_settings_remote_datasource.dart'
    as _i273;
import '../feature/user_settings/data/datasource/user_settings_remote_datasource_impl.dart'
    as _i463;
import '../feature/user_settings/data/di/user_settings_hive_module.dart'
    as _i1027;
import '../feature/user_settings/data/model/user_settings_hive_model.dart'
    as _i537;
import '../feature/user_settings/data/repository/user_settings_repository_impl.dart'
    as _i740;
import '../feature/user_settings/domain/repository/user_settings_repository.dart'
    as _i293;
import '../feature/user_settings/domain/usecase/get_user_settings.dart'
    as _i943;
import '../feature/user_settings/domain/usecase/update_user_settings.dart'
    as _i831;
import '../feature/user_settings/presentation/locale_bloc.dart' as _i237;
import 'firestore_module.dart' as _i431;
import 'uuid_module.dart' as _i78;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final uuidModule = _$UuidModule();
    final firestoreModule = _$FirestoreModule();
    final todoHiveModule = _$TodoHiveModule();
    final userSettginsHiveModule = _$UserSettginsHiveModule();
    gh.factory<_i706.Uuid>(() => uuidModule.provideUuid());
    gh.factory<_i974.FirebaseFirestore>(() => firestoreModule.firestore);
    await gh.factoryAsync<_i979.Box<_i345.TodoHiveModel>>(
      () => todoHiveModule.provideTodoBox(),
      preResolve: true,
    );
    await gh.factoryAsync<_i979.Box<_i537.UserSettingsHiveModel>>(
      () => userSettginsHiveModule.provideUserSettingsBox(),
      preResolve: true,
    );
    gh.factory<_i494.TodoLocalDataSource>(() => _i1027.TodoLocalDataSourceImpl(
        box: gh<_i979.Box<_i345.TodoHiveModel>>()));
    gh.factory<_i228.UserSettingsLocalDataSource>(() =>
        _i147.UserSettingsLocalDatasourceImpl(
            box: gh<_i979.Box<_i537.UserSettingsHiveModel>>()));
    gh.factory<_i47.TodoRemoteDataSource>(() => _i592.TodoRemoteDatasourceImpl(
        firestore: gh<_i974.FirebaseFirestore>()));
    gh.factory<_i953.TodoRepository>(() => _i491.TodoReositoryImpl(
          localDataSource: gh<_i494.TodoLocalDataSource>(),
          remoteDataSource: gh<_i47.TodoRemoteDataSource>(),
          uuid: gh<_i706.Uuid>(),
        ));
    gh.factory<_i273.UserSettingsRemoteDataSource>(() =>
        _i463.UserSettingsRemoteDatasourceImpl(
            firestore: gh<_i974.FirebaseFirestore>()));
    gh.factory<_i306.DeleteTodoUsecase>(() =>
        _i306.DeleteTodoUsecase(todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i273.AddTodoUsecase>(
        () => _i273.AddTodoUsecase(todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i489.UpdateTodoUsecase>(() =>
        _i489.UpdateTodoUsecase(todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i422.GetAllTodoUsecase>(() =>
        _i422.GetAllTodoUsecase(todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i896.TodoBloc>(() => _i896.TodoBloc(
          addTodoUsecase: gh<_i273.AddTodoUsecase>(),
          deleteTodoUsecase: gh<_i306.DeleteTodoUsecase>(),
          updateTodoDescriptionUsecase: gh<_i489.UpdateTodoUsecase>(),
          getAllTodoUsecase: gh<_i422.GetAllTodoUsecase>(),
        ));
    gh.factory<_i293.UserSettingsRepository>(
        () => _i740.UserSettingsRepositoryImpl(
              localDataSource: gh<_i228.UserSettingsLocalDataSource>(),
              remoteDataSource: gh<_i273.UserSettingsRemoteDataSource>(),
            ));
    gh.factory<_i943.GetUserSettings>(() =>
        _i943.GetUserSettings(repository: gh<_i293.UserSettingsRepository>()));
    gh.factory<_i831.UpdateUserSettings>(() => _i831.UpdateUserSettings(
        repository: gh<_i293.UserSettingsRepository>()));
    gh.factory<_i237.LocaleBloc>(() => _i237.LocaleBloc(
          getUserSettings: gh<_i943.GetUserSettings>(),
          updateUserSettings: gh<_i831.UpdateUserSettings>(),
        ));
    return this;
  }
}

class _$UuidModule extends _i78.UuidModule {}

class _$FirestoreModule extends _i431.FirestoreModule {}

class _$TodoHiveModule extends _i657.TodoHiveModule {}

class _$UserSettginsHiveModule extends _i1027.UserSettginsHiveModule {}
