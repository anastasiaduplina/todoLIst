import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_list_app/data/dao/actions_dao.dart';
import 'package:todo_list_app/data/dao/actions_dao_impl.dart';
import 'package:todo_list_app/data/dto/action_dto.dart';

void main() {
  late final ActionsDao actionsDao;
  ActionDto actionDto1 = ActionDto(
    "95fa8270-3378-107b-8a64-21991b22a182",
    "text",
    true,
    446546352,
    ImportanceDto.basic,
    "#FFFFFF",
    69124165,
    223455645,
    "device id",
  );
  ActionDto actionDto2 = ActionDto(
    "87fa8270-3378-107b-8a64-21991b22a182",
    "text",
    true,
    446546352,
    ImportanceDto.basic,
    "#FFFFFF",
    69124165,
    223455645,
    "device id",
  );
  ActionDto actionDto3 = ActionDto(
    "56fa8270-3378-107b-8a64-21991b22a182",
    "text",
    false,
    3605065,
    ImportanceDto.basic,
    "#FFFFFF",
    69124165,
    223455645,
    "device id",
  );

  setUpAll(() {
    actionsDao = ActionsDaoImpl();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });
  setUp(() async {
    await actionsDao.clearTable();
  });

  test('Check database adding', () async {
    List<ActionDto> list = [];
    await actionsDao.addAction(actionDto1);

    list = await actionsDao.getAll();

    expect(list.length, 1);
    expect(list[0], actionDto1);
  });
  test('Check database edit', () async {
    List<ActionDto> list = [];
    await actionsDao.addAction(actionDto1);
    actionDto1.done = false;
    await actionsDao.editAction(actionDto1);

    list = await actionsDao.getAll();

    expect(list.length, 1);
    expect(list[0].done, isFalse);
  });
  test('Check database delete', () async {
    List<ActionDto> list = [];
    await actionsDao.addAction(actionDto1);
    await actionsDao.deleteAction(actionDto1);

    list = await actionsDao.getAll();

    expect(list, isEmpty);
  });
  test('Check database getById', () async {
    List<ActionDto> list = [];
    await actionsDao.addAction(actionDto1);
    await actionsDao.addAction(actionDto2);
    ActionDto actionDto = await actionsDao.getActionById(actionDto1.id);

    list = await actionsDao.getAll();

    expect(list.length, 2);
    expect(actionDto, actionDto1);
  });
  test('Check database updateList', () async {
    List<ActionDto> list = [];
    await actionsDao.addAction(actionDto1);
    await actionsDao.addAction(actionDto2);
    actionDto2.text = "vrbrtr";
    List<ActionDto> updatedList = [actionDto1,actionDto2,actionDto3];
    await actionsDao.updateList(updatedList);

    list = await actionsDao.getAll();

    expect(list.length, updatedList.length);
    expect(list, updatedList);
  });
}
