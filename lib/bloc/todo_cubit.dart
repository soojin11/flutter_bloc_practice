import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_block_pattern/bloc/todo_state.dart';
import 'package:todo_block_pattern/model/todo.dart';
import 'package:todo_block_pattern/repository/todo_repository.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository repository;
  TodoCubit({required this.repository}) : super(Empty());

  //method로 바로
  listTodo() async {
    try {
      emit(Loading());
      final resp = await repository.listTodo();
      final todos = resp.map<Todo>((e) => Todo.fromJson(e)).toList();
      emit(Loaded(todos: todos));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  //event없이 바로 title을 받아
  createTodo(String title) async {
    try {
      if (state is Loaded) {
        final parsedState = (state as Loaded);
        final newTodo = Todo(
            id: parsedState.todos[parsedState.todos.length - 1].id + 1,
            //cubit에서는 event 를 따로 사용하지 않으므로
            // title: event.title,
            title: title,
            createAt: DateTime.now().toString());
        final prevTodos = [...parsedState.todos];
        final newTodos = [...prevTodos, newTodo];

        emit(Loaded(todos: newTodos));
        final resp = await repository.createTodo(newTodo);
        emit(Loaded(todos: [...prevTodos, Todo.fromJson(resp)]));
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  deleteTodo(Todo todo) async {
    try {
      if (state is Loaded) {
        final newTodos = (state as Loaded)
            .todos
            .where((item) => item.id != todo.id)
            .toList();
        emit(Loaded(todos: newTodos));

        await repository.deleteTodo(todo);
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
