// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:uuid/uuid.dart' as _i706;

import '../feature/todo/data/di/todo_hive_module.dart' as _i657;
import '../feature/todo/data/model/todo_model.dart' as _i823;
import '../feature/todo/data/repository/todo_repository_impl.dart' as _i491;
import '../feature/todo/domain/repository/todo_repository.dart' as _i953;
import '../feature/todo/domain/usecase/add_todo_usecase.dart' as _i273;
import '../feature/todo/domain/usecase/delete_todo_usecase.dart' as _i306;
import '../feature/todo/domain/usecase/get_all_todo_usecase.dart' as _i422;
import '../feature/todo/domain/usecase/update_todo_usecase.dart' as _i489;
import '../feature/todo/presentation/todo_bloc.dart' as _i896;
import 'shared_module.dart' as _i521;

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
    final sharedModule = _$SharedModule();
    final todoHiveModule = _$TodoHiveModule();
    gh.singleton<_i706.Uuid>(() => sharedModule.provideUuid());
    await gh.singletonAsync<_i979.Box<_i823.TodoModel>>(
      () => todoHiveModule.provideTodoBox(),
      preResolve: true,
    );
    gh.factory<_i953.TodoRepository>(() => _i491.TodoReositoryImpl(
          todoBox: gh<_i979.Box<_i823.TodoModel>>(),
          uuid: gh<_i706.Uuid>(),
        ));
    gh.factory<_i306.DeleteTodoUsecase>(() =>
        _i306.DeleteTodoUsecase(todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i273.AddTodoUsecase>(
        () => _i273.AddTodoUsecase(todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i422.GetAllTodoUsecase>(() =>
        _i422.GetAllTodoUsecase(todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i489.UpdateTodoUsecase>(() =>
        _i489.UpdateTodoUsecase(todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i896.TodoBloc>(() => _i896.TodoBloc(
          addTodoUsecase: gh<_i273.AddTodoUsecase>(),
          deleteTodoUsecase: gh<_i306.DeleteTodoUsecase>(),
          updateTodoDescriptionUsecase: gh<_i489.UpdateTodoUsecase>(),
          getAllTodoUsecase: gh<_i422.GetAllTodoUsecase>(),
        ));
    return this;
  }
}

class _$SharedModule extends _i521.SharedModule {}

class _$TodoHiveModule extends _i657.TodoHiveModule {}
