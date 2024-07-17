import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/ui/providers/action_provider.dart';
import 'package:todo_list_app/ui/providers/theme/theme_provider.dart';
import 'package:todo_list_app/ui/screens/home/widgets/action_list_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_list_app/utils/logger.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/model/action.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends ConsumerState<MyHomePage> {
  late bool eyeON;
  late TextEditingController textController;
  final scrollController = ScrollController();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    eyeON = true;
    textController = TextEditingController(text: "");
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      AppLogger.e('Couldn\'t check connectivity status:$e');
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (_connectionStatus[0] == ConnectivityResult.none &&
        result[0] != ConnectivityResult.none) {
      await ref.read(actionStateProvider.notifier).synchronizeList(true);
    }
    setState(() {
      _connectionStatus = result;
    });

    AppLogger.i('Connectivity changed: $_connectionStatus');
  }

  int countDoneActions(List<ActionToDo> list) {
    int count = list.where((item) => item.done).length;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<ActionToDo> items = ref.watch(actionStateProvider).valueOrNull ?? [];
    bool isDark = ref.watch(themeStateProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 160,
            backgroundColor: theme.scaffoldBackgroundColor,
            shadowColor: theme.shadowColor,
            surfaceTintColor: theme.cardColor,
            actions: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: (_connectionStatus[0] == ConnectivityResult.none)
                    ? const Icon(Icons.wifi_off)
                    : const Icon(Icons.wifi),
              ),
              IconButton(
                onPressed: () {
                  ref.read(themeStateProvider.notifier).changeTheme();
                },
                icon: isDark
                    ? const Icon(Icons.nightlight)
                    : const Icon(Icons.sunny),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).myTasks,
                    style: theme.textTheme.headlineMedium,
                  ),
                  IconButton(
                    onPressed: () {
                      AppLogger.d("eyeON is $eyeON");
                      setState(() {
                        eyeON = !eyeON;
                      });
                    },
                    icon: !eyeON
                        ? const Icon(Icons.visibility_outlined)
                        : const Icon(Icons.visibility_off_outlined),
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
              child: Center(
                child: Text(
                  '${AppLocalizations.of(context).completed} - ${countDoneActions(items)}',
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: items.length,
                      controller: scrollController,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if ((!eyeON && items[index].done)) {
                          return const SizedBox.shrink();
                        }
                        return ActionTile(action: items[index]);
                      },
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 32.0,
                            right: 32,
                            bottom: 128,
                          ),
                          child: TextFormField(
                            controller: textController,
                            maxLines: 3,
                            minLines: 1,
                            scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            onTap: () {
                              // TODO(nastya): быстрое добавление
                              //  пока перекидывает на обычную страницу добавления
                              AppLogger.d("Push AddAction Page");
                              context.goNamed(
                                "task",
                                pathParameters: {
                                  'id': "-1",
                                },
                              );
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context).newTask,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          AppLogger.d("Push AddAction Page");
          context.goNamed(
            "task",
            pathParameters: {
              'id': "-1",
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
