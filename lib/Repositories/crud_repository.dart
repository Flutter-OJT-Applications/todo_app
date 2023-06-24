
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/main.dart';

abstract class CRUDRepository<E>{
  Future<List<E>?>  list();
  Future<E?> getById(id);
  Future<int?> create(Map<String, Object?> data);
  Future<int?> update(id,Map<String, Object?> data);
  Future<int?> delete(id);
  Database get database => entityManager.database;
}