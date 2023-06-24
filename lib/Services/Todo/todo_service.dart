
import 'package:flutter/cupertino.dart';
import 'package:todo_app/Models/Todo/todo_model.dart';
import 'package:todo_app/Repositories/Todo/todo_repository.dart';

class TodoService{
  late TodoRepository _repository;
  late List<TodoModel> _todoList;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  late bool isLoading;

  TodoService(){
    _repository = TodoRepository();
    _todoList = <TodoModel>[];
  }

  Future<List<TodoModel>?> getTodoList() async{
    await Future.delayed(const Duration(seconds: 2));
    return await _repository.list();
  }

  Future<TodoModel?> createTodo(TodoModel model) async{
    final id = await _repository.create(model.toObject());
    if(id == null){
      return null;
    }
    model.id = id;
    return model;
  }

  Future<TodoModel?> getTodoById(int id){
    return _repository.getById(id);
  }

  Future<TodoModel?> updateTodo(int id, TodoModel model) async{
    final updatedId = await _repository.update(id, model.toObject());
    if(updatedId == null) {
      return null;
    }
    return model;
  }

  Future<bool> deleteTodo(int id) async{
    final deletedId = await _repository.delete(id);
    if(deletedId == null) return false;
    return true;
  }

  List<TodoModel> get  todoList => _todoList;

  set setTodoList(List<TodoModel> modelList) => _todoList = modelList;

  set addTodo(TodoModel model){
    _todoList.add(model);
  }
}