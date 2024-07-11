import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/data/dao/list_dao.dart';
import 'package:todo_list_app/data/dao/list_dao_impl.dart';
import 'package:todo_list_app/data/dto/action_dto.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late final ListDao listDao;
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
    listDao = ListDaoImpl();
  });
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();

    await listDao.getList();
    await listDao.updateList([]);
  });

  test('Check api adding', () async {
    await listDao.addAction(actionDto1);
    List<ActionDto> list = await listDao.getList();
    expect(list.length, 1);
    expect(list[0], actionDto1);
  });
  test('Check api edit', () async {
    await listDao.addAction(actionDto1);
    actionDto1.text = "woyeeter";
    await listDao.editAction(actionDto1);
    List<ActionDto> list = await listDao.getList();
    expect(list.length, 1);
    expect(list[0], actionDto1);
  });
  test('Check api delete', () async {
    await listDao.addAction(actionDto1);
    await listDao.deleteAction(actionDto1);
    List<ActionDto> list = await listDao.getList();
    expect(list, isEmpty);
  });
  test('Check api getById', () async {
    await listDao.addAction(actionDto1);
    await listDao.addAction(actionDto2);
    ActionDto actionDto = await listDao.getActionById(actionDto1.id);
    expect(actionDto, actionDto1);
  });
  test('Check api updateList', () async {
    await listDao.addAction(actionDto1);
    await listDao.addAction(actionDto2);
    List<ActionDto> list = await listDao.updateList([actionDto3]);
    expect(list.length, 1);
    expect(list[0], actionDto3);
  });
}
