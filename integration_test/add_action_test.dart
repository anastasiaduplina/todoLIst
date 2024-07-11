import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/data/dao/actions_dao.dart';
import 'package:todo_list_app/data/dao/actions_dao_impl.dart';
import 'package:todo_list_app/data/dao/list_dao.dart';
import 'package:todo_list_app/data/dao/list_dao_impl.dart';
import 'package:todo_list_app/ui/my_app.dart';
import 'package:todo_list_app/ui/screens/home/widgets/action_list_tile.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late final ActionsDao actionsDao;
  late final ListDao listDao;

  setUpAll(() {
    actionsDao = ActionsDaoImpl();
    listDao = ListDaoImpl();
  });
  setUp(() async {
    await actionsDao.clearTable();
    await listDao.getList();
    await listDao.updateList([]);
  });
  Future<void> initApp(WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('должен создавать новый элемент TodoItem в списке задач',
      (tester) async {
    await initApp(tester);

    final addButton = find.byIcon(Icons.add);
    await tester.tap(addButton);
    await tester.pumpAndSettle();
    final textField = find.byType(TextFormField);
    await tester.enterText(textField, "test");
    await tester.pumpAndSettle();

    final saveButton = find.byKey(const Key("saveButton"));
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.byType(ActionTile), findsOneWidget);
    expect(find.text("test"), findsOneWidget);

    expect(find.text("Мои дела"), findsOneWidget);
  });
}
