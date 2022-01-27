import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_block_pattern/bloc/todo_bloc.dart';
import 'package:todo_block_pattern/bloc/todo_cubit.dart';
import 'package:todo_block_pattern/bloc/todo_event.dart';
import 'package:todo_block_pattern/bloc/todo_state.dart';
import 'package:todo_block_pattern/repository/todo_repository.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // create: (_) => TodoBloc(repository: TodoRepository()),
      create: (_) => TodoCubit(repository: TodoRepository()),
      child: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String title = '';
  @override
  void initState() {
    super.initState();
    //여기서 ListTodosEvent를 불러줘
    //Bloc class에서 원래 add method가 있음
    // BlocProvider.of<TodoBloc>(context).add(ListTodosEvent());
    BlocProvider.of<TodoCubit>(context).listTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Flutter Bloc"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // context.read<TodoBloc>().add(CreateTodosEvent(title: title));
              context.read<TodoCubit>().createTodo(title);
            },
            child: const Icon(Icons.edit),
          ),
          body: Column(
            children: [
              TextField(
                onChanged: (v) {
                  title = v;
                },
              ),
              const SizedBox(height: 16),
              //BlocBuilder는 rebuild
              //BlocListener는 rebuild 안하고 listening만

              Expanded(
                  // child: BlocBuilder<TodoBloc, TodoState>(builder: (_, state) {
                  child: BlocBuilder<TodoCubit, TodoState>(builder: (_, state) {
                if (state is Empty) {
                  return Container();
                } else if (state is Error) {
                  return Text(state.message);
                } else if (state is Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is Loaded) {
                  //todo를 가져와
                  final items = state.todos;

                  return ListView.separated(
                      itemBuilder: (_, index) {
                        final item = items[index];
                        return Row(
                          children: [
                            Expanded(child: Text(item.title)),
                            GestureDetector(
                              onTap: () {
                                // BlocProvider.of<TodoBloc>(context)
                                //     .add(DeleteTodosEvent(todo: item));
                                BlocProvider.of<TodoCubit>(context)
                                    .deleteTodo(item);
                              },
                              child: const Icon(Icons.delete),
                            )
                          ],
                        );
                      },
                      separatorBuilder: (_, index) => const Divider(),
                      itemCount: items.length);
                }
                return Container();
              }))
            ],
          ),
        ));
  }
}
