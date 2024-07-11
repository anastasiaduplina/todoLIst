import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/data/dao/actions_dao.dart';
import 'package:todo_list_app/data/dao/actions_dao_impl.dart';
import 'package:todo_list_app/data/dao/list_dao.dart';
import 'package:todo_list_app/data/dao/list_dao_impl.dart';
import 'package:uuid/uuid.dart';

import '../data/mapper/action_mapper.dart';
import '../data/mapper/importance_mapper.dart';
import '../data/repository/actions_api_repository_impl.dart';
import '../data/repository/actions_db_repository_impl.dart';
import '../domain/repository/actions_api_repository.dart';
import '../domain/repository/actions_db_repository.dart';

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

  static final actionDBRepositoryProvider = Provider<ActionsDBRepository>(
    (ref) => ActionsDBRepositoryImpl(
      ref.read(actionsDaoProvider),
      ref.read(actionsMapperProvider),
    ),
  );
  static final actionAPIRepositoryProvider = Provider<ActionsAPIRepository>(
    (ref) => ActionsAPIRepositoryImpl(
      ref.read(actionsDaoProvider),
      ref.read(listDaoProvider),
      ref.read(actionsMapperProvider),
    ),
  );
}
