
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todo_app/Models/Todo/todo_model.dart';
import 'package:todo_app/Repositories/Todo/todo_repository.dart';

class TodoService extends GetxController{
  final TodoRepository _repository = TodoRepository();
  final List<TodoModel> _todoList = <TodoModel>[].obs;
  final formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController().obs;
  final _descriptionController = TextEditingController().obs;

  final _isLoading = true.obs;

  @override
  void onInit() async{
    super.onInit();
    await _fetchTodo();
    _isLoading.value = false;
  }

  _fetchTodo() async {
    final data = await getTodoList();
    if(data != null) {
      _todoList.addAll(data);
    }
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
    _todoList.add(model);
    return model;
  }

  Future<TodoModel?> getTodoById(int id){
    return _repository.getById(id);
  }

  Future<TodoModel?> updateTodo(int id, TodoModel model) async{
    final count = await _repository.update(id, model.toObject());
    if(count == null) {
      return null;
    }
    int index = _todoList.indexWhere((todo) => todo.id == id);
    if(index == -1) {
      return null;
    }
    _todoList[index] = model;
    return model;
  }

  Future<bool> deleteTodo(int id) async{
    final count = await _repository.delete(id);
    if(count == null) return false;
    _todoList.removeWhere((todo) => todo.id == id);
    return true;
  }

  List<TodoModel> get  todoList => _todoList;

  set setTodoList(List<TodoModel> modelList) => _todoList.addAll(modelList);

  set addTodo(TodoModel model){
    _todoList.add(model);
  }

  TextEditingController get titleController => _titleController.value;
  TextEditingController get descriptionController => _descriptionController.value;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
}