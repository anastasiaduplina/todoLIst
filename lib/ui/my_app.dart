import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_app/themes/light_theme.dart';
import 'package:todo_list_app/ui/providers/theme/theme_provider.dart';
import 'package:todo_list_app/ui/screens/add_edit_action/add_action.dart';
import 'package:todo_list_app/ui/screens/home/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../themes/dark_theme.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const MyHomePage(),
      routes: <RouteBase>[
        GoRoute(
          name: 'task',
          path: 'task/:id',
          builder: (context, state) =>
              AddActionPage(state.pathParameters["id"]!),
        ),
      ],
    ),
  ],
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(themeStateProvider);
    return MaterialApp.router(
      routerConfig: _router,
      title: 'News app',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
    );
  }
}
