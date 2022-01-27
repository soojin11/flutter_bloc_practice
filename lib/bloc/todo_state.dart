import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_block_pattern/model/todo.dart';

@immutable
abstract class TodoState extends Equatable {}

//state 1. 아무것도 안들어있다

class Empty extends TodoState {
  @override
  List<Object> get props => [];
}

//state 2. 로딩 중(repository 불렀을 때)
class Loading extends TodoState {
  @override
  List<Object> get props => [];
}

//state 3. 에러
class Error extends TodoState {
  final String message;
  Error({required this.message});

  @override
  List<Object> get props => [message];
}

//state 4. 로딩 완료, 데이터 들어옴
class Loaded extends TodoState {
  final List<Todo> todos;
  Loaded({required this.todos});
  @override
  List<Object> get props => [todos];
}
