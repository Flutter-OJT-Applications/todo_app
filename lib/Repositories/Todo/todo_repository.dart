import 'package:todo_app/Repositories/crud_repository.dart';

import '../../Models/Todo/todo_model.dart';

class TodoRepository extends CRUDRepository<TodoModel> {
  @override
  Future<int?> create(Map<String, Object?> data) async {
    return await database.insert('todo', data);
  }

  @override
  Future<int?> delete(id) async {
    return await database.delete('todo', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<TodoModel?> getById(id) async {
    final data = await database.query('todo', where: 'id = ?', whereArgs: [id]);
    if(data.isEmpty) return null;
    return TodoModel.fromDB(data.single);
  }

  @override
  Future<List<TodoModel>?> list() async{
    final data = await database.query('todo');
    return data.map((e) => TodoModel.fromDB(e)).toList();
  }

  @override
  Future<int?> update(id,Map<String, Object?> data) async{
    return await database.update('todo', data, where: 'id = ?', whereArgs: [id]);
  }
}
