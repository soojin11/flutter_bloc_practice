import 'package:todo_block_pattern/model/todo.dart';

class TodoRepository {
  Future<List<Map<String, dynamic>>> listTodo() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      {
        'id': 1,
        'title': 'Flutter 배우기',
        'createAt': DateTime.now().toString(),
      },
      {
        'id': 2,
        'title': 'Dart 배우기',
        'createAt': DateTime.now().toString(),
      }
    ];
  }

  //todo를 인자값으로 받아야지만 todo를 생성할 수 있음
  Future<Map<String, dynamic>> createTodo(Todo todo) async {
    await Future.delayed(const Duration(seconds: 1));

    return todo.toJson();
  }

  Future<Map<String, dynamic>> deleteTodo(Todo todo) async {
    await Future.delayed(const Duration(seconds: 1));

    return todo.toJson();
  }
}
