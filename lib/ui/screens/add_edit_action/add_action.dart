import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/ui/providers/action_provider.dart';
import 'package:todo_list_app/utils/logger.dart';
import 'package:todo_list_app/utils/scaffold_messege_extension.dart';

import '../../../domain/model/action.dart';
import '../../../utils/exceptions/not_exist_action_exception.dart';
import '../../../utils/exceptions/not_valid_auth_exception.dart';
import '../../../utils/exceptions/not_valid_revision_exception.dart';
import '../../../utils/exceptions/server_error_exception.dart';

class AddActionPage extends ConsumerStatefulWidget {
  const AddActionPage(
    this.id, {
    super.key,
  });

  final String id;

  @override
  AddActionPageState createState() => AddActionPageState();
}

class AddActionPageState extends ConsumerState<AddActionPage> {
  late TextEditingController textController;
  late ActionToDo action;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    action = getEmptyAction();
    isFirst = true;

    textController = TextEditingController(text: action.text);
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
    setState(() {
      _connectionStatus = result;
    });
    AppLogger.i('Connectivity changed: $_connectionStatus');
  }

  void setPickedDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      AppLogger.d(
        "Change deadline of action.id: ${action.id} to $pickedDate",
      );
      setState(() {
        action.deadline = pickedDate;
      });
    }
  }

  String getImportanceString(Importance importance, BuildContext context) {
    switch (importance) {
      case Importance.no:
        return AppLocalizations.of(context).importanceBasic;
      case Importance.low:
        return AppLocalizations.of(context).importanceLow;
      case Importance.high:
        return AppLocalizations.of(context).importanceHigh;
    }
  }

  @override
  build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    var theme = Theme.of(context);
    final DateFormat formatter =
        DateFormat('dd MMMM yyyy', AppLocalizations.of(context).localeName);
    List<ActionToDo> list = ref.watch(actionStateProvider).value ?? [];
    if (isFirst) {
      action = list.firstWhere(
        (item) => item.id == widget.id,
        orElse: () => getEmptyAction(),
      );
      textController.text = action.text;
      isFirst = false;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: theme.cardColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            AppLogger.d("Navigator pop from AddActionPage");
            FirebaseAnalytics.instance.logEvent(
              name: 'pop',
              parameters: {
                'pageFrom': 'addAction',
                'pageTo': 'home',
              },
            );
            context.pop();
          },
        ),
        actions: [
          TextButton(
            key: const Key("saveButton"),
            onPressed: () async {
              AppLogger.d("Save action.id: ${action.id}");

              action.text = textController.text;
              try {
                await ref.read(actionStateProvider.notifier).addOrEditAction(
                      action,
                      (_connectionStatus[0] != ConnectivityResult.none),
                    );
              } on NotValidRevisionException catch (e) {
                messenger.toastButton(e.toString(), () {
                  ref.read(actionStateProvider.notifier).synchronizeList(
                        (_connectionStatus[0] != ConnectivityResult.none),
                      );
                });
              } on NotExistActionException catch (e) {
                messenger.toast(e.toString());
              } on NotValidAuthException catch (e) {
                messenger.toast(e.toString());
              } on ServerErrorException catch (e) {
                messenger.toast(e.toString());
              } catch (e) {
                messenger.toast(e.toString());
              }
              AppLogger.d("Navigator pop from AddActionPage");
              FirebaseAnalytics.instance.logEvent(
                name: 'pop',
                parameters: {
                  'pageFrom': 'addAction',
                  'pageTo': 'home',
                },
              );
              if (context.mounted) {
                context.pop();
              }
            },
            child: Text(
              AppLocalizations.of(context).save,
              style: theme.textTheme.titleSmall?.copyWith(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: textController,
                maxLines: 10,
                minLines: 4,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: AppLocalizations.of(context).hint,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).importance,
                    style: theme.textTheme.titleMedium,
                  ),
                  MenuAnchor(
                    style: MenuStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        theme.cardColor,
                      ),
                      surfaceTintColor: WidgetStateProperty.all<Color>(
                        theme.cardColor,
                      ),
                    ),
                    builder: (
                      BuildContext context,
                      MenuController controller,
                      Widget? child,
                    ) {
                      return TextButton(
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        child: Text(
                          getImportanceString(action.importance, context),
                          style: theme.textTheme.labelLarge
                              ?.copyWith(color: Colors.grey),
                        ),
                      );
                    },
                    menuChildren: List<MenuItemButton>.generate(
                      3,
                      (int index) => MenuItemButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            theme.cardColor,
                          ),
                        ),
                        onPressed: () {
                          AppLogger.d(
                            "Change importance of action.id: ${action.id} to ${Importance.values[index]}",
                          );
                          setState(
                            () => action.importance = Importance.values[index],
                          );
                        },
                        child: Text(
                          getImportanceString(
                            Importance.values[index],
                            context,
                          ),
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: (Importance.values[index] == Importance.high)
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).doUntil,
                    style: theme.textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () => action.deadlineON ? setPickedDate() : {},
                    child: action.deadlineON
                        ? Text(
                            formatter.format(action.deadline),
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: Colors.blue),
                          )
                        : const Text(""),
                  ),
                  Switch(
                    value: action.deadlineON,
                    activeColor: Colors.blue,
                    onChanged: (bool value) {
                      AppLogger.d(
                        "Change deadlineON of action.id: ${action.id} to $value",
                      );
                      setState(() {
                        action.deadlineON = value;
                      });
                    },
                  ),
                ],
              ),
              const Divider(),
              TextButton.icon(
                onPressed: () async {
                  AppLogger.d("Delete action.id: ${action.id}");
                  FirebaseAnalytics.instance.logEvent(
                    name: 'delete',
                    parameters: {
                      'action': action.id,
                    },
                  );
                  try {
                    await ref.read(actionStateProvider.notifier).deleteAction(
                          action,
                          (_connectionStatus[0] != ConnectivityResult.none),
                        );
                  } on NotValidRevisionException catch (e) {
                    messenger.toastButton(e.toString(), () {
                      ref.read(actionStateProvider.notifier).synchronizeList(
                            (_connectionStatus[0] != ConnectivityResult.none),
                          );
                    });
                  } on NotExistActionException catch (e) {
                    messenger.toast(e.toString());
                  } on NotValidAuthException catch (e) {
                    messenger.toast(e.toString());
                  } on ServerErrorException catch (e) {
                    messenger.toast(e.toString());
                  } catch (e) {
                    messenger.toast(e.toString());
                  }
                  AppLogger.d("Navigator pop from AddActionPage");
                  FirebaseAnalytics.instance.logEvent(
                    name: 'pop',
                    parameters: {
                      'pageFrom': 'addAction',
                      'pageTo': 'home',
                    },
                  );

                  if (context.mounted) {
                    context.pop();
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                label: Text(
                  AppLocalizations.of(context).delete,
                  style:
                      theme.textTheme.labelLarge?.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
