import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/utils/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ui/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  if (kReleaseMode) {
    AppLogger.disable();
  }
  AppLogger.i("Start app");
  runApp(
    const ProviderScope(child: MyApp()),
  );
  // runZonedGuarded<Future<void>>(() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  //
  //   FlutterError.onError =
  //       FirebaseCrashlytics.instance.recordFlutterFatalError;
  //
  //   runApp(MyApp());
  // }, (error, stack) =>
  //     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}
