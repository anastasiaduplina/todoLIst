import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/data/dao/actions_dao.dart';
import 'package:todo_list_app/data/dao/actions_dao_impl.dart';
import 'package:todo_list_app/data/dao/list_dao.dart';
import 'package:todo_list_app/data/dao/list_dao_impl.dart';
import 'package:todo_list_app/domain/mapper/action_mapper.dart';
import 'package:todo_list_app/domain/mapper/importance_mapper.dart';
import 'package:todo_list_app/domain/repository/actions_repository.dart';
import 'package:todo_list_app/domain/repository/actions_repository_impl.dart';
import 'package:uuid/uuid.dart';

final uuidProvider = Provider((ref) => const Uuid());
final importanceMapperProvider = Provider<ImportanceMapper>(
  (ref) => ImportanceMapper(),
);

final actionsMapperProvider = Provider<ActionsMapper>(
  (ref) => ActionsMapper(ref.read(importanceMapperProvider)),
);
final listDaoProvider = Provider<ListDao>(
  (ref) => ListDaoImpl(),
);
final actionsDaoProvider = Provider<ActionsDao>(
  (ref) => ActionsDaoImpl(),
);

final actionRepositoryProvider = Provider<ActionsRepository>(
  (ref) => ActionsRepositoryImpl(
    ref.read(uuidProvider),
    ref.read(actionsDaoProvider),
    ref.read(listDaoProvider),
    ref.read(actionsMapperProvider),
  ),
);
