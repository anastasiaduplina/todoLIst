import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/data/dto/action_dto.dart';
import 'package:todo_list_app/utils/logger.dart';

import 'actions_dao.dart';

class ActionsDaoImpl implements ActionsDao {
  ActionsDaoImpl();

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          """CREATE TABLE Actions(
            id TEXT PRIMARY KEY ,
            text TEXT NOT NULL ,
            done TEXT NOT NULL ,
            deadline INTEGER ,
            importance TEXT NOT NULL ,
            color TEXT NOT NULL ,
            created_at INTEGER NOT NULL ,
            changed_at INTEGER NOT NULL ,
            last_updated_by TEXT NOT NULL
            )
            """,
        );
      },
      version: 1,
    );
  }

  @override
  Future<void> addAction(ActionDto actionDto) async {
    final Database db = await initializeDB();
    try {
      final _ = await db.insert(
        'Actions',
        actionDto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      AppLogger.i("Success add action to db");
    } catch (err) {
      AppLogger.e(err.toString());
    }
  }

  @override
  Future<void> deleteAction(ActionDto actionDto) async {
    final Database db = await initializeDB();
    try {
      await db.delete(
        "Actions",
        where: """
      id = ?
      """,
        whereArgs: [
          actionDto.id,
        ],
      );
      AppLogger.i("Success delete action from db");
    } catch (err) {
      AppLogger.e(err.toString());
    }
  }

  @override
  Future<void> editAction(ActionDto actionDto) async {
    final Database db = await initializeDB();
    try {
      await db.update(
        "Actions",
        actionDto.toJson(),
        where: """
      id = ?
      """,
        whereArgs: [
          actionDto.id,
        ],
      );
      AppLogger.i("Success edit action to db");
    } catch (err) {
      AppLogger.e(err.toString());
    }
  }

  @override
  Future<List<ActionDto>> getAll() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Actions');
    return queryResult.map((e) {
      ActionDto actionDto = ActionDto.fromJson(e);
      return actionDto;
    }).toList();
  }
}
