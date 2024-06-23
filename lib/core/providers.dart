import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/domain/repository/actions_repository.dart';
import 'package:todo_list_app/domain/repository/actions_repository_impl.dart';

final actionRepositoryProvider = Provider<ActionsRepository>(
  (ref) => ActionsRepositoryImplTest(),
);
