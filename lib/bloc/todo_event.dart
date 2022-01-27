//cubit or bloc
//event 개수는 rest API end point 개수와 거의 일치

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_block_pattern/model/todo.dart';

@immutable
abstract class TodoEvent extends Equatable {}

class ListTodosEvent extends TodoEvent {
  @override
  List<Object> get props => [];
}

class CreateTodosEvent extends TodoEvent {
  final String title;
  CreateTodosEvent({required this.title});
  @override
  List<Object> get props => [title];
}

class DeleteTodosEvent extends TodoEvent {
  final Todo todo;
  DeleteTodosEvent({required this.todo});
  @override
  List<Object> get props => [todo];
}
