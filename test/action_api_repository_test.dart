import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_list_app/data/dao/actions_dao_impl.dart';
import 'package:todo_list_app/data/dao/list_dao_impl.dart';
import 'package:todo_list_app/data/mapper/action_mapper.dart';
import 'package:todo_list_app/data/mapper/importance_mapper.dart';
import 'package:todo_list_app/data/repository/actions_api_repository_impl.dart';
import 'package:todo_list_app/domain/model/action.dart';
import 'package:todo_list_app/domain/repository/actions_api_repository.dart';

class MockListDao extends Mock implements ListDaoImpl {}

class MockActionsDao extends Mock implements ActionsDaoImpl {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late final MockActionsDao actionsDao;
  late final MockListDao listDao;
  late final ActionsAPIRepository apiRepository;
  late final ActionsMapper actionsMapper;
  ActionToDo actionTodo1 = ActionToDo(
    "95fa8270-3378-107b-8a64-21991b22a182",
    "text",
    true,
    true,
    DateTime.fromMillisecondsSinceEpoch(4533683),
    Importance.no,
    "#FFFFFF",
    DateTime.fromMillisecondsSinceEpoch(4533683),
    DateTime.fromMillisecondsSinceEpoch(45336857),
    "device id",
  );
  ActionToDo actionTodo2 = ActionToDo(
    "95fa8270-3378-107b-8a64-21991b22a178",
    "text",
    false,
    true,
    DateTime.fromMillisecondsSinceEpoch(3294264),
    Importance.no,
    "#FFFFFF",
    DateTime.fromMillisecondsSinceEpoch(291515),
    DateTime.fromMillisecondsSinceEpoch(23673776),
    "device id",
  );
  ActionToDo actionTodo3 = ActionToDo(
    "987a8270-3378-107b-8a64-21991b22a182",
    "text",
    true,
    false,
    DateTime.fromMillisecondsSinceEpoch(4533683),
    Importance.no,
    "#FFFFFF",
    DateTime.fromMillisecondsSinceEpoch(01637),
    DateTime.fromMillisecondsSinceEpoch(14876407),
    "device id",
  );

  setUpAll(() {
    listDao = MockListDao();
    actionsDao = MockActionsDao();
    actionsMapper = ActionsMapper(ImportanceMapper());
    apiRepository =
        ActionsAPIRepositoryImpl(actionsDao, listDao, actionsMapper);
    registerFallbackValue(actionsMapper.mapActionToActionDto(actionTodo1));
    registerFallbackValue(actionsMapper.mapActionToActionDto(actionTodo2));
    registerFallbackValue(actionsMapper.mapActionToActionDto(actionTodo3));
  });
  setUp(() async {});

  test('Check api repository adding', () async {
    when(() => listDao.addAction(any())).thenAnswer((_) async => {});
    when(() => listDao.getList()).thenAnswer(
      (_) async => [
        actionsMapper.mapActionToActionDto(
          ActionToDo(
            "95fa8270-3378-107b-8a64-21991b22a182",
            "text",
            true,
            true,
            DateTime.fromMillisecondsSinceEpoch(4533683),
            Importance.no,
            "#FFFFFF",
            DateTime.fromMillisecondsSinceEpoch(4533683),
            DateTime.fromMillisecondsSinceEpoch(45336857),
            "device id",
          ),
        ),
      ],
    );
    await apiRepository.addAction(actionTodo1);
    List<ActionToDo> list = await apiRepository.getAll();
    expect(list.length, 1);
    expect(list[0].id, actionTodo1.id);
  });
  test('Check api repository edit', () async {
    when(() => listDao.editAction(any())).thenAnswer((_) async => {});
    when(() => listDao.getList()).thenAnswer(
      (_) async => [
        actionsMapper.mapActionToActionDto(
          ActionToDo(
            "95fa8270-3378-107b-8a64-21991b22a182",
            "gygegbre",
            true,
            true,
            DateTime.fromMillisecondsSinceEpoch(4533683),
            Importance.no,
            "#FFFFFF",
            DateTime.fromMillisecondsSinceEpoch(4533683),
            DateTime.fromMillisecondsSinceEpoch(45336857),
            "device id",
          ),
        ),
      ],
    );
    await apiRepository.addAction(actionTodo1);
    actionTodo1.text = "gygegbre";
    await apiRepository.editAction(actionTodo1);
    List<ActionToDo> list = await apiRepository.getAll();
    expect(list.length, 1);
    expect(list[0].id, actionTodo1.id);
    expect(list[0].text, actionTodo1.text);
  });
  test('Check api repository delete', () async {
    when(() => listDao.deleteAction(any())).thenAnswer((_) async => {});
    when(() => listDao.getList()).thenAnswer(
      (_) async => [
        actionsMapper.mapActionToActionDto(
          ActionToDo(
            "95fa8270-3378-107b-8a64-21991b22a182",
            "gygegbre",
            true,
            true,
            DateTime.fromMillisecondsSinceEpoch(4533683),
            Importance.no,
            "#FFFFFF",
            DateTime.fromMillisecondsSinceEpoch(4533683),
            DateTime.fromMillisecondsSinceEpoch(45336857),
            "device id",
          ),
        ),
      ],
    );
    await apiRepository.addAction(actionTodo1);
    await apiRepository.addAction(actionTodo2);
    await apiRepository.deleteAction(actionTodo2);
    List<ActionToDo> list = await apiRepository.getAll();
    expect(list.length, 1);
    expect(list[0].id, actionTodo1.id);
    expect(list[0].text, actionTodo1.text);
  });
  test('Check api repository getById', () async {
    when(() => listDao.getActionById(any())).thenAnswer(
      (_) async => actionsMapper.mapActionToActionDto(
        ActionToDo(
          "95fa8270-3378-107b-8a64-21991b22a182",
          "gygegbre",
          true,
          true,
          DateTime.fromMillisecondsSinceEpoch(4533683),
          Importance.no,
          "#FFFFFF",
          DateTime.fromMillisecondsSinceEpoch(4533683),
          DateTime.fromMillisecondsSinceEpoch(45336857),
          "device id",
        ),
      ),
    );
    await apiRepository.addAction(actionTodo1);
    await apiRepository.addAction(actionTodo2);
    ActionToDo actionToDo = await apiRepository.getById(actionTodo1.id);
    expect(actionToDo.id, actionTodo1.id);
    expect(actionToDo.text, actionTodo1.text);
  });

  test('Check api repository synchronize', () async {
    when(() => listDao.updateList(any())).thenAnswer((_) async => []);
    when(() => actionsDao.updateList(any())).thenAnswer((_) async => []);
    when(() => actionsDao.getAll()).thenAnswer((_) async => []);
    await apiRepository.addAction(actionTodo1);
    await apiRepository.addAction(actionTodo2);
    List<ActionToDo> list = await apiRepository.synchronizeList();
    expect(list, isEmpty);
  });
}
