import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/utils/logger.dart';

import 'ui/my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kReleaseMode) {
    AppLogger.disable();
  }
  AppLogger.i("Start app");
  runApp(
    const ProviderScope(child: MyApp()),
  );
}
