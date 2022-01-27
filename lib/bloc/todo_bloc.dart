import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_block_pattern/bloc/todo_event.dart';
import 'package:todo_block_pattern/bloc/todo_state.dart';
import 'package:todo_block_pattern/model/todo.dart';
import 'package:todo_block_pattern/repository/todo_repository.dart';

// bloc logic
// flutter_bloc 8.~ version
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;
  TodoBloc({required this.repository}) : super(Empty()) {
    on<ListTodosEvent>((event, emit) async {
      try {
        emit(Loading());
        final resp = await repository.listTodo();
        final todos = resp.map<Todo>((e) => Todo.fromJson(e)).toList();
        emit(Loaded(todos: todos));
      } catch (e) {
        emit(Error(message: e.toString()));
      }
    });
    on<CreateTodosEvent>((event, emit) async {
      try {
        if (state is Loaded) {
          final parsedState = (state as Loaded);
          final newTodo = Todo(
              id: parsedState.todos[parsedState.todos.length - 1].id + 1,
              title: event.title,
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
    });
    on<DeleteTodosEvent>((event, emit) async {
      try {
        if (state is Loaded) {
          final newTodos = (state as Loaded)
              .todos
              .where((todo) => todo.id != event.todo.id)
              .toList();
          emit(Loaded(todos: newTodos));

          await repository.deleteTodo(event.todo);
        }
      } catch (e) {
        emit(Error(message: e.toString()));
      }
    });
  }
}


//flutter_bloc 7.x version
//지금 이거 안돼
// class TodoBloc extends Bloc<TodoEvent, TodoState> {
//   //가장 기본이 되는 state를 넣어줘
//   //처음에 bloc 생성하면 아무것도 안들어있을거니까
//   //프론트엔드에서 로직을 다 빼버리는게 bloc의 목적

//   final TodoRepository repository;

//   //dependency injection
//   TodoBloc({required this.repository}) : super(Empty());
//   // TodoBloc({required this.repository}) : super(Empty()) {
//   //   on<TodoEvent>((event, emit) {
//   //     if (event is ListTodosEvent) {
//   //       _mapListTodosEvent(event, emit);
//   //     } else if (event is CreateTodosEvent) {
//   //       _mapCreateTodosEvent(event, emit);
//   //     } else if (event is DeleteTodosEvent) {
//   //       _mapDeleteTodosEvent(event, emit);
//   //     }
//   //   });
//   // }

//   @override
//   Stream<TodoState> mapEventToState(TodoEvent event) async* {
//     //각 이벤트 별로 함수를 실행해서 로직 실행시킴
//     if (event is ListTodosEvent) {
//       //yield* iterable이나 stream 함수를 재귀적으로 호출하는데 사용
//       //UI와 첫번째로 만나는 logic
//       yield* _mapListTodosEvent(event);
//     } else if (event is CreateTodosEvent) {
//       yield* _mapCreateTodosEvent(event);
//     } else if (event is DeleteTodosEvent) {
//       yield* _mapDeleteTodosEvent(event);
//     }
//   }

//   Stream<TodoState> _mapListTodosEvent(ListTodosEvent event) async* {
//     //이벤트들이 stream 형태로 들어가
//     //ui에서 에러 나는 것을 최소화 => 모든 에러를 여기서 잡아버려
//     try {
//       //첫번째로 해아할 일 => 이때 circular indicator 보여주면 돼
//       yield Loading();
//       //결국 해야할 것
//       //listTodo를 resp 에 저장해
//       final resp = await repository.listTodo();
//       //todo를 만들어
//       final todos = resp.map<Todo>((e) => Todo.fromJson(e)).toList();
//       //로딩이 다 됐으면 loaded state를 return
//       yield Loaded(todos: todos);
//     } catch (e) {
//       yield Error(message: e.toString());
//     }
//   }

//   Stream<TodoState> _mapCreateTodosEvent(CreateTodosEvent event) async* {
//     try {
//       //기존 데이터를 가져와
//       //모든 yield 된 데이터를 state로 가져올 수 있음
//       if (state is Loaded) {
//         //기존에 있던 todo
//         final parsedState = (state as Loaded);

//         //createTodo를 가공
//         //문제점은 id랑 createAt을 임의로 저장했음 => 가짜 데이터
//         //왜 이렇게 했냐 => 실제 요청이 끝나기 전에 끝난 것처럼 해서 빨라보이게
//         final newTodo = Todo(
//             id: parsedState.todos[parsedState.todos.length - 1].id + 1,
//             title: event.title,
//             createAt: DateTime.now().toString());

//         //일단은 기존 상태를 저장
//         final prevTodos = [...parsedState.todos];

//         //새로 생기는 todo는 기존 todo에다가 newTodo를 추가
//         //newTodos 는 가짜 todo
//         final newTodos = [...prevTodos, newTodo];

//         //로드가 다 됐다고 뻥쳐서 화면에 보여지게 함
//         yield Loaded(todos: newTodos);

//         //서버 요청이 끝나고 나면 진짜 데이터로 바꿔줘
//         final resp = await repository.createTodo(newTodo);
//         // yield Loaded(todos: [...prevTodos, Todo.fromJson(resp)]);
//       }
//     } catch (e) {
//       yield Error(message: e.toString());
//     }
//   }

//   Stream<TodoState> _mapDeleteTodosEvent(DeleteTodosEvent event) async* {
    // try {
    //   if (state is Loaded) {
    //     //지울때 이거 많이 사용함
    //     //지우기 전에 지워진 값을 먼저 보여주기 위해서
    //     //지우는것은 가정한 것이랑 무조건 똑같기 때문에 다시 업데이트 안해줘도 됨
    //     final newTodos = (state as Loaded)
    //         .todos
    //         .where((todo) => todo.id != event.todo.id)
    //         .toList();
    //     yield Loaded(todos: newTodos);

    //     await repository.deleteTodo(event.todo);
    //   }
    // } catch (e) {
    //   yield Error(message: e.toString());
    // }
//   }
// }
