import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/data/dao/actions_dao.dart';
import 'package:todo_list_app/data/dao/actions_dao_impl.dart';
import 'package:todo_list_app/data/dao/list_dao.dart';
import 'package:todo_list_app/data/dao/list_dao_impl.dart';
import 'package:todo_list_app/domain/repository/actions_repository.dart';
import 'package:todo_list_app/data/repository/actions_repository_impl.dart';
import 'package:uuid/uuid.dart';

import '../data/mapper/action_mapper.dart';
import '../data/mapper/importance_mapper.dart';

class Providers {
  static final uuidProvider = Provider((ref) => const Uuid());
  static final importanceMapperProvider = Provider<ImportanceMapper>(
    (ref) => ImportanceMapper(),
  );

  static final actionsMapperProvider = Provider<ActionsMapper>(
    (ref) => ActionsMapper(ref.read(importanceMapperProvider)),
  );
  static final listDaoProvider = Provider<ListDao>(
    (ref) => ListDaoImpl(),
  );
  static final actionsDaoProvider = Provider<ActionsDao>(
    (ref) => ActionsDaoImpl(),
  );

  static final actionRepositoryProvider = Provider<ActionsRepository>(
    (ref) => ActionsRepositoryImpl(
      ref.read(uuidProvider),
      ref.read(actionsDaoProvider),
      ref.read(listDaoProvider),
      ref.read(actionsMapperProvider),
    ),
  );
}
