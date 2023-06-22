
import 'package:todo_app/Repositories/Todo/todo_repository.dart';
import 'package:todo_app/Repositories/repository.dart';

class TodoService{
  late CRUDRepository _repository;
  TodoService(){
    _repository = TodoRepository();
  }

}