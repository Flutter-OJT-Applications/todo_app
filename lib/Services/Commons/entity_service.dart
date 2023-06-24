import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EntityService {
  late Database _database;

  EntityService();

  Future<void> initialize() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    _database = await openDatabase(path, version: 1, onCreate: _onDbCreate); //
  }

  Future<void> _onDbCreate(Database db, int version) async{
    await db.execute(
        'CREATE TABLE IF NOT EXISTS todo (id INTEGER PRIMARY KEY, title VARCHAR(50), description TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)');
  }
  get database => _database;
}
