import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/feature/todo/data/datasource/todo_local_data_source.dart';
import 'package:todo_app/feature/todo/data/datasource/todo_remote_data_source.dart';
import 'package:todo_app/feature/todo/data/mapper/todo_mapper.dart';
import 'package:todo_app/feature/todo/data/model/todo_firestore_model.dart';
import 'package:todo_app/feature/todo/data/model/todo_hive_model.dart';
import 'package:todo_app/feature/todo/data/repository/todo_repository_impl.dart';
import 'package:todo_app/feature/todo/domain/entity/todo.dart';
import 'package:uuid/uuid.dart';

import 'todo_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TodoLocalDataSource>(),
  MockSpec<TodoRemoteDataSource>(),
  MockSpec<Uuid>(),
])
void main() {
  final mockUuid = MockUuid();
  final mockTodoLocalDataSource = MockTodoLocalDataSource();
  final mockTodoRemoteDataSource = MockTodoRemoteDataSource();

  final todoRepository = TodoReositoryImpl(
    localDataSource: mockTodoLocalDataSource,
    remoteDataSource: mockTodoRemoteDataSource,
    uuid: mockUuid,
  );
  const firstLocalTodoId = 'id1';
  const firstLocalTodoDescription = 'First todo';
  const firstLocalTodoIsDone = false;
  final firstLocalTodoUpdatedAt = DateTime.parse('2021-01-01');
  final firstLocalTodoCreatedAt = DateTime.parse('2021-01-01');
  const firstLocalTodoIsDeleted = false;
  final firstLocalTodoDoneStatusChangedAt = DateTime.parse('2021-01-01');

  final todo = Todo(
    id: firstLocalTodoId,
    description: firstLocalTodoDescription,
    isDone: firstLocalTodoIsDone,
    updatedAt: firstLocalTodoUpdatedAt,
    createdAt: firstLocalTodoCreatedAt,
    isDeleted: firstLocalTodoIsDeleted,
    doneStatusChangedAt: firstLocalTodoDoneStatusChangedAt,
  );

  final firstLocalTodo = TodoHiveModel(
    id: firstLocalTodoId,
    description: firstLocalTodoDescription,
    isDone: firstLocalTodoIsDone,
    updatedAt: firstLocalTodoUpdatedAt,
    createdAt: firstLocalTodoCreatedAt,
    isDeleted: firstLocalTodoIsDeleted,
    doneStatusChangedAt: firstLocalTodoDoneStatusChangedAt,
  );

  final firstRemoteTodo = TodoFirestoreModel(
    id: firstLocalTodoId,
    description: firstLocalTodoDescription,
    isDone: firstLocalTodoIsDone,
    updatedAt: firstLocalTodoUpdatedAt,
    createdAt: firstLocalTodoCreatedAt,
    isDeleted: firstLocalTodoIsDeleted,
    doneStatusChangedAt: firstLocalTodoDoneStatusChangedAt,
  );

  test('should create a todo in local data source', () async {
    when(mockUuid.v4()).thenReturn(firstLocalTodoId);
    // This stub is not necessary when using GenerateNiceMocks
    when(mockTodoLocalDataSource.create(firstLocalTodo))
        .thenAnswer((_) async {});
    await todoRepository.add(firstLocalTodoDescription);
    verify(mockTodoLocalDataSource.create(
      argThat(
        isA<TodoHiveModel>()
            .having((t) => t.id, '', firstLocalTodo.id)
            .having((t) => t.description, '', firstLocalTodo.description),
      ),
    )).called(1);
  });

  test('should get all todos from local data source', () async {
    when(mockTodoLocalDataSource.getAll())
        .thenAnswer((_) async => [firstLocalTodo]);
    final todos = await todoRepository.getAll();
    expect(todos, [todo]);
  });

  test('should mark todo to remove later and save it in the local data source',
      () async {
    // This stub is not necessary when using GenerateNiceMocks
    when(mockTodoLocalDataSource.update(any)).thenAnswer((_) async {});
    when(mockTodoLocalDataSource.get(firstLocalTodoId))
        .thenAnswer((_) async => firstLocalTodo);
    await todoRepository.remove(firstLocalTodoId);
    verify(mockTodoLocalDataSource.update(
      argThat(
        isA<TodoHiveModel>()
            .having((t) => t.id, '', firstLocalTodo.id)
            .having((t) => t.isDeleted, '', true)
            .having((t) => t.description, '', firstLocalTodo.description),
      ),
    )).called(1);
    verifyNever(mockTodoLocalDataSource.delete(firstLocalTodoId));
  });

  group('should update todo and save it in the local data source', () {
    // This stub is not necessary when using GenerateNiceMocks
    when(mockTodoLocalDataSource.update(any)).thenAnswer((_) async {});
    test(
      'should not modify local todo if none of description and isDone changes',
      () async {
        when(mockTodoLocalDataSource.get(firstLocalTodoId))
            .thenAnswer((_) async => firstLocalTodo);
        await todoRepository.update(firstLocalTodoId);
        verify(mockTodoLocalDataSource.update(
          argThat(
            isA<TodoHiveModel>()
                .having((t) => t.id, '', firstLocalTodo.id)
                .having((t) => t.isDone, '', firstLocalTodo.isDone)
                .having((t) => t.isDeleted, '', firstLocalTodo.isDeleted)
                .having((t) => t.description, '', firstLocalTodo.description)
                .having((t) => t.createdAt, '', firstLocalTodo.createdAt)
                .having((t) => t.doneStatusChangedAt, '',
                    firstLocalTodo.doneStatusChangedAt)
                .having((t) => t.updatedAt, '', firstLocalTodo.updatedAt),
          ),
        )).called(1);
        verifyNever(mockTodoLocalDataSource.delete(firstLocalTodoId));
      },
    );

    test(
      'should modify local todo if description changes',
      () async {
        const newDescription = 'New description';
        when(mockTodoLocalDataSource.get(firstLocalTodoId))
            .thenAnswer((_) async => firstLocalTodo);
        await todoRepository.update(
          firstLocalTodoId,
          description: 'New description',
        );
        verify(mockTodoLocalDataSource.update(
          argThat(
            isA<TodoHiveModel>()
                .having((t) => t.id, '', firstLocalTodo.id)
                .having((t) => t.isDone, '', firstLocalTodo.isDone)
                .having((t) => t.isDeleted, '', firstLocalTodo.isDeleted)
                .having((t) => t.description, '', newDescription)
                .having((t) => t.createdAt, '', firstLocalTodo.createdAt)
                .having((t) => t.doneStatusChangedAt, '',
                    firstLocalTodo.doneStatusChangedAt)
                .having((t) => t.updatedAt.isAfter(firstLocalTodo.updatedAt),
                    '', true),
          ),
        )).called(1);
        verifyNever(mockTodoLocalDataSource.delete(firstLocalTodoId));
      },
    );

    test(
      'should modify local todo if isDone changes',
      () async {
        when(mockTodoLocalDataSource.get(firstLocalTodoId))
            .thenAnswer((_) async => firstLocalTodo);
        await todoRepository.update(
          firstLocalTodoId,
          isDone: !firstLocalTodo.isDone,
        );
        verify(mockTodoLocalDataSource.update(
          argThat(
            isA<TodoHiveModel>()
                .having((t) => t.id, '', firstLocalTodo.id)
                .having((t) => t.isDone, '', !firstLocalTodo.isDone)
                .having((t) => t.isDeleted, '', firstLocalTodo.isDeleted)
                .having((t) => t.description, '', firstLocalTodo.description)
                .having((t) => t.createdAt, '', firstLocalTodo.createdAt)
                .having(
                    (t) => t.doneStatusChangedAt
                        .isAfter(firstLocalTodo.doneStatusChangedAt),
                    '',
                    true)
                .having((t) => t.updatedAt.isAfter(firstLocalTodo.updatedAt),
                    '', true),
          ),
        )).called(1);
        verifyNever(mockTodoLocalDataSource.delete(firstLocalTodoId));
      },
    );
  });

  group('should sync todos', () {
    group('should delete todos that are marked to be deleted', () {
      test('from local and remote both', () async {
        assert(TodoMapper.fromHiveModel(firstLocalTodo) ==
            TodoMapper.fromFirestoreModel(firstRemoteTodo));

        final deletedLocalTodo = firstLocalTodo.copyWith(isDeleted: true);

        when(mockTodoLocalDataSource.getAll())
            .thenAnswer((_) async => [deletedLocalTodo]);
        when(mockTodoRemoteDataSource.getAll())
            .thenAnswer((_) async => [firstRemoteTodo]);
        when(mockTodoLocalDataSource.sync(
          deleteModelIds: anyNamed('deleteModelIds'),
          updateModels: anyNamed('updateModels'),
          createModels: anyNamed('createModels'),
        )).thenAnswer((_) async {});
        when(mockTodoRemoteDataSource.sync(
          deleteModelIds: anyNamed('deleteModelIds'),
          updateModels: anyNamed('updateModels'),
          createModels: anyNamed('createModels'),
        )).thenAnswer((_) async {});

        await todoRepository.sync();
        verify(mockTodoLocalDataSource.sync(
          deleteModelIds: argThat(
            isA<List<String>>().having((t) => t, '', [deletedLocalTodo.id]),
            named: 'deleteModelIds',
          ),
          updateModels: [],
          createModels: [],
        )).called(1);
        verify(mockTodoRemoteDataSource.sync(
          deleteModelIds: argThat(
            isA<List<String>>().having((t) => t, '', [firstRemoteTodo.id]),
            named: 'deleteModelIds',
          ),
          updateModels: [],
          createModels: [],
        )).called(1);
      });
      test('from local only', () async {
        assert(TodoMapper.fromHiveModel(firstLocalTodo) ==
            TodoMapper.fromFirestoreModel(firstRemoteTodo));

        final deletedLocalTodo =
            firstLocalTodo.copyWith(isDeleted: true, id: 'new id');

        when(mockTodoLocalDataSource.getAll())
            .thenAnswer((_) async => [deletedLocalTodo]);
        when(mockTodoRemoteDataSource.getAll()).thenAnswer((_) async => []);
        when(mockTodoLocalDataSource.sync(
          deleteModelIds: anyNamed('deleteModelIds'),
          updateModels: anyNamed('updateModels'),
          createModels: anyNamed('createModels'),
        )).thenAnswer((_) async {});
        when(mockTodoRemoteDataSource.sync(
          deleteModelIds: anyNamed('deleteModelIds'),
          updateModels: anyNamed('updateModels'),
          createModels: anyNamed('createModels'),
        )).thenAnswer((_) async {});

        await todoRepository.sync();
        verify(mockTodoLocalDataSource.sync(
          deleteModelIds: argThat(
            isA<List<String>>().having((t) => t, '', [deletedLocalTodo.id]),
            named: 'deleteModelIds',
          ),
          updateModels: [],
          createModels: [],
        )).called(1);
        verify(mockTodoRemoteDataSource.sync(
          deleteModelIds: [],
          updateModels: [],
          createModels: [],
        )).called(1);
      });
      test('from remote only', () async {
        assert(TodoMapper.fromHiveModel(firstLocalTodo) ==
            TodoMapper.fromFirestoreModel(firstRemoteTodo));

        final deletedRemoteTodo =
            firstRemoteTodo.copyWith(isDeleted: true, id: 'new id');

        when(mockTodoLocalDataSource.getAll()).thenAnswer((_) async => []);
        when(mockTodoRemoteDataSource.getAll())
            .thenAnswer((_) async => [deletedRemoteTodo]);
        when(mockTodoLocalDataSource.sync(
          deleteModelIds: anyNamed('deleteModelIds'),
          updateModels: anyNamed('updateModels'),
          createModels: anyNamed('createModels'),
        )).thenAnswer((_) async {});
        when(mockTodoRemoteDataSource.sync(
          deleteModelIds: anyNamed('deleteModelIds'),
          updateModels: anyNamed('updateModels'),
          createModels: anyNamed('createModels'),
        )).thenAnswer((_) async {});

        await todoRepository.sync();
        verify(mockTodoLocalDataSource.sync(
          deleteModelIds: [],
          updateModels: [],
          createModels: [],
        )).called(1);
        verify(mockTodoRemoteDataSource.sync(
          deleteModelIds: argThat(
            isA<List<String>>().having((t) => t, '', [deletedRemoteTodo.id]),
            named: 'deleteModelIds',
          ),
          updateModels: [],
          createModels: [],
        )).called(1);
      });
    });
    test(
        'should not change the local or remote todos if they contain same items',
        () async {
      assert(TodoMapper.fromHiveModel(firstLocalTodo) ==
          TodoMapper.fromFirestoreModel(firstRemoteTodo));

      when(mockTodoLocalDataSource.getAll())
          .thenAnswer((_) async => [firstLocalTodo]);
      when(mockTodoRemoteDataSource.getAll())
          .thenAnswer((_) async => [firstRemoteTodo]);
      when(mockTodoLocalDataSource.sync(
        deleteModelIds: anyNamed('deleteModelIds'),
        updateModels: anyNamed('updateModels'),
        createModels: anyNamed('createModels'),
      )).thenAnswer((_) async {});
      when(mockTodoRemoteDataSource.sync(
        deleteModelIds: anyNamed('deleteModelIds'),
        updateModels: anyNamed('updateModels'),
        createModels: anyNamed('createModels'),
      )).thenAnswer((_) async {});

      await todoRepository.sync();
      verify(mockTodoLocalDataSource.sync(
        deleteModelIds: [],
        updateModels: [],
        createModels: [],
      )).called(1);
      verify(mockTodoRemoteDataSource.sync(
        deleteModelIds: [],
        updateModels: [],
        createModels: [],
      )).called(1);
    });

    test('should replace local todos by remote todos', () async {
      assert(TodoMapper.fromHiveModel(firstLocalTodo) ==
          TodoMapper.fromFirestoreModel(firstRemoteTodo));

      final updateDateTime = DateTime.now();

      final updateRemoteTodo = firstRemoteTodo.copyWith(
        description: 'Update',
        updatedAt: updateDateTime,
      );
      when(mockTodoLocalDataSource.getAll())
          .thenAnswer((_) async => [firstLocalTodo]);
      when(mockTodoRemoteDataSource.getAll())
          .thenAnswer((_) async => [updateRemoteTodo]);
      when(mockTodoLocalDataSource.sync(
        deleteModelIds: anyNamed('deleteModelIds'),
        updateModels: anyNamed('updateModels'),
        createModels: anyNamed('createModels'),
      )).thenAnswer((_) async {});
      when(mockTodoRemoteDataSource.sync(
        deleteModelIds: anyNamed('deleteModelIds'),
        updateModels: anyNamed('updateModels'),
        createModels: anyNamed('createModels'),
      )).thenAnswer((_) async {});

      await todoRepository.sync();
      verify(mockTodoLocalDataSource.sync(
        deleteModelIds: [],
        updateModels: argThat(
            isA<List<TodoHiveModel>>().having((t) => t, '', isNotEmpty),
            named: 'updateModels'),
        createModels: [],
      )).called(1);
      verify(mockTodoRemoteDataSource.sync(
        deleteModelIds: [],
        updateModels: [],
        createModels: [],
      )).called(1);
    });

    test('should replace remote todos by local todos', () async {
      assert(TodoMapper.fromHiveModel(firstLocalTodo) ==
          TodoMapper.fromFirestoreModel(firstRemoteTodo));

      final updateDateTime = DateTime.now();

      final updatedLocalTodo = firstLocalTodo.copyWith(
        description: 'Update',
        updatedAt: updateDateTime,
      );
      when(mockTodoLocalDataSource.getAll())
          .thenAnswer((_) async => [updatedLocalTodo]);
      when(mockTodoRemoteDataSource.getAll())
          .thenAnswer((_) async => [firstRemoteTodo]);
      when(mockTodoLocalDataSource.sync(
        deleteModelIds: anyNamed('deleteModelIds'),
        updateModels: anyNamed('updateModels'),
        createModels: anyNamed('createModels'),
      )).thenAnswer((_) async {});
      when(mockTodoRemoteDataSource.sync(
        deleteModelIds: anyNamed('deleteModelIds'),
        updateModels: anyNamed('updateModels'),
        createModels: anyNamed('createModels'),
      )).thenAnswer((_) async {});

      await todoRepository.sync();
      verify(mockTodoLocalDataSource.sync(
        deleteModelIds: [],
        updateModels: [],
        createModels: [],
      )).called(1);
      verify(mockTodoRemoteDataSource.sync(
        deleteModelIds: [],
        updateModels: argThat(
            isA<List<TodoFirestoreModel>>().having((t) => t, '', isNotEmpty),
            named: 'updateModels'),
        createModels: [],
      )).called(1);
    });

    test('should fill missing todos reciprocally', () async {
      assert(TodoMapper.fromHiveModel(firstLocalTodo) ==
          TodoMapper.fromFirestoreModel(firstRemoteTodo));

      when(mockTodoLocalDataSource.getAll()).thenAnswer(
          (_) async => [firstLocalTodo.copyWith(id: 'new local id')]);
      when(mockTodoRemoteDataSource.getAll()).thenAnswer(
          (_) async => [firstRemoteTodo.copyWith(id: 'new remote id')]);
      when(mockTodoLocalDataSource.sync(
        deleteModelIds: anyNamed('deleteModelIds'),
        updateModels: anyNamed('updateModels'),
        createModels: anyNamed('createModels'),
      )).thenAnswer((_) async {});
      when(mockTodoRemoteDataSource.sync(
        deleteModelIds: anyNamed('deleteModelIds'),
        updateModels: anyNamed('updateModels'),
        createModels: anyNamed('createModels'),
      )).thenAnswer((_) async {});

      await todoRepository.sync();
      verify(mockTodoLocalDataSource.sync(
        deleteModelIds: [],
        updateModels: [],
        createModels: argThat(
            isA<List<TodoHiveModel>>().having((t) => t, '', isNotEmpty),
            named: 'createModels'),
      )).called(1);
      verify(mockTodoRemoteDataSource.sync(
        deleteModelIds: [],
        updateModels: [],
        createModels: argThat(
            isA<List<TodoFirestoreModel>>().having((t) => t, '', isNotEmpty),
            named: 'createModels'),
      )).called(1);
    });
  });
}
