import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/data/dto/action_dto.dart';
import 'package:todo_list_app/utils/logger.dart';

import 'actions_dao.dart';

class ActionsDaoImpl implements ActionsDao {
  ActionsDaoImpl();

  Database? db;

  Future<void> initializeDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          """CREATE TABLE Actions(
            id TEXT PRIMARY KEY ,
            text TEXT NOT NULL ,
            done INTEGER NOT NULL ,
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
  Future<void> clearTable() async {
    checkInit();
    int? result = await db?.rawDelete("DELETE FROM Actions");
    List<ActionDto> list = await getAll();
    if (list.isNotEmpty || result == null) {
      result = await db?.rawDelete("DELETE FROM Actions");
    }
  }

  Future<void> checkInit() async {
    if (db == null) {
      await initializeDB();
    }
    if (!db!.isOpen) {
      await initializeDB();
    }
  }

  @override
  Future<void> addAction(ActionDto actionDto) async {
    checkInit();
    var values = actionDto.toJson();
    values["done"] = actionDto.done ? 1 : 0;
    try {
      final _ = await db?.insert(
        'Actions',
        values,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      AppLogger.i("Success add action to db");
    } catch (err) {
      AppLogger.e(err.toString());
    }
  }

  @override
  Future<void> deleteAction(ActionDto actionDto) async {
    checkInit();
    try {
      await db?.delete(
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
    checkInit();
    var values = actionDto.toJson();
    values["done"] = actionDto.done ? 1 : 0;
    try {
      await db?.update(
        "Actions",
        values,
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
    await checkInit();
    final List<Map<String, Object?>> queryResult =
        await db?.query('Actions') as List<Map<String, Object?>>;
    return queryResult.map((e) {
      ActionDto actionDto = ActionDto.fromJson(e);
      return actionDto;
    }).toList();
  }

  @override
  Future<ActionDto> getActionById(String id) async {
    checkInit();
    var result = await db?.query(
      "Actions",
      where: " id = ? ",
      whereArgs: [id],
    );
    ActionDto? actionDto = result!.isNotEmpty
        ? result.map((c) => ActionDto.fromJson(c)).toList()[0]
        : null;
    return actionDto as ActionDto;
  }

  @override
  Future<void> updateList(List<ActionDto> list) async {
    checkInit();

    try {
      for (ActionDto actionDto in list) {
        var values = actionDto.toJson();
        values["done"] = actionDto.done ? 1 : 0;
        await db?.insert(
          'Actions',
          values,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (err) {
      AppLogger.e(err.toString());
    }
  }
}
