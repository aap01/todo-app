// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../feature/todo/data/repository/todo_repository_impl.dart' as _i491;
import '../feature/todo/domain/repository/todo_repository.dart' as _i953;
import '../feature/todo/domain/usecase/add_todo_usecase.dart' as _i273;
import '../feature/todo/domain/usecase/complete_todo_usecase.dart' as _i134;
import '../feature/todo/domain/usecase/delete_todo_usecase.dart' as _i306;
import '../feature/todo/domain/usecase/get_all_todo_usecase.dart' as _i422;
import '../feature/todo/domain/usecase/undo_complete_todo_usecase.dart'
    as _i257;
import '../feature/todo/domain/usecase/update_todo_description_usecase.dart'
    as _i364;
import '../feature/todo/presentation/todo_bloc.dart' as _i896;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i953.TodoRepository>(() => _i491.TodoReositoryImpl());
    gh.factory<_i306.DeleteTodoUsecase>(() =>
        _i306.DeleteTodoUsecase(todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i273.AddTodoUsecase>(
        () => _i273.AddTodoUsecase(todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i422.GetAllTodoUsecase>(() =>
        _i422.GetAllTodoUsecase(todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i257.UndoCompleteTodoUsecase>(() =>
        _i257.UndoCompleteTodoUsecase(
            todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i364.UpdateTodoDescriptionUsecase>(() =>
        _i364.UpdateTodoDescriptionUsecase(
            todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i134.CompleteTodoUsecase>(() =>
        _i134.CompleteTodoUsecase(todoRepository: gh<_i953.TodoRepository>()));
    gh.factory<_i896.TodoBloc>(() => _i896.TodoBloc(
          addTodoUsecase: gh<_i273.AddTodoUsecase>(),
          completeTodoUsecase: gh<_i134.CompleteTodoUsecase>(),
          deleteTodoUsecase: gh<_i306.DeleteTodoUsecase>(),
          updateTodoDescriptionUsecase:
              gh<_i364.UpdateTodoDescriptionUsecase>(),
          undoCompleteTodoUsecase: gh<_i257.UndoCompleteTodoUsecase>(),
          getAllTodoUsecase: gh<_i422.GetAllTodoUsecase>(),
        ));
    return this;
  }
}
