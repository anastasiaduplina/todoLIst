import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_list_app/utils/exceptions/not_exist_action_exception.dart';
import 'package:todo_list_app/utils/exceptions/not_valid_auth_exception.dart';
import 'package:todo_list_app/utils/exceptions/not_valid_revision_exception.dart';
import 'package:todo_list_app/utils/exceptions/server_error_exception.dart';
import 'package:todo_list_app/utils/scaffold_messege_extension.dart';

import '../../../../domain/model/action.dart';
import '../../../../utils/logger.dart';
import '../../../providers/action_provider.dart';

class ActionTile extends ConsumerStatefulWidget {
  const ActionTile({
    super.key,
    required this.action,
  });

  final ActionToDo action;

  @override
  ConsumerState<ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends ConsumerState<ActionTile> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  @override
  void initState() {
    super.initState();
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

  IconData? getImportanceIcon(Importance importance) {
    if (importance == Importance.high) {
      return Icons.priority_high;
    }
    if (importance == Importance.low) {
      return Icons.arrow_downward;
    }
    return null;
  }

  Color getImportanceColor(Importance importance) {
    return (importance == Importance.high) ? Colors.red : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    var theme = Theme.of(context);
    final DateFormat formatter =
        DateFormat('dd MMMM yyyy', AppLocalizations.of(context).localeName);
    return Dismissible(
      key: Key(widget.action.id.toString()),
      dismissThresholds: const {DismissDirection.startToEnd: 0.3},
      resizeDuration: const Duration(milliseconds: 500),
      movementDuration: const Duration(milliseconds: 300),
      background: const ColoredBox(
        color: Colors.green,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.done, color: Colors.white),
          ),
        ),
      ),
      secondaryBackground: const ColoredBox(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        AppLogger.d("Swipe direction: $direction");
        if (direction == DismissDirection.startToEnd) {
          AppLogger.d("Mark done action.id: ${widget.action.id}");
          try {
            await ref.read(actionStateProvider.notifier).markDoneOrNot(
                widget.action,
                true,
                (_connectionStatus[0] != ConnectivityResult.none),);
          } on NotValidRevisionException catch (e) {
            messenger.toastButton(e.toString(), () {
              ref.read(actionStateProvider.notifier).synchronizeList(
                  (_connectionStatus[0] != ConnectivityResult.none),);
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
          return false;
        } else if (direction == DismissDirection.endToStart) {
          return true;
        }
        return false;
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          AppLogger.d("Delete action.id: ${widget.action.id}");
          try {
            await ref.read(actionStateProvider.notifier).deleteAction(
                widget.action,
                (_connectionStatus[0] != ConnectivityResult.none),);
          } on NotValidRevisionException catch (e) {
            messenger.toastButton(e.toString(), () {
              ref.read(actionStateProvider.notifier).synchronizeList(
                  (_connectionStatus[0] != ConnectivityResult.none),);
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
        }
      },
      child: ListTile(
        key: Key(widget.action.id.toString()),
        titleAlignment: ListTileTitleAlignment.top,
        leading: Checkbox(
          activeColor: Colors.green,
          value: widget.action.done,
          side: BorderSide(
            color: getImportanceColor(widget.action.importance),
            width: 2,
          ),
          onChanged: (bool? value) async {
            try {
              await ref.read(actionStateProvider.notifier).markDoneOrNot(
                  widget.action,
                  !widget.action.done,
                  (_connectionStatus[0] != ConnectivityResult.none),);
            } on NotValidRevisionException catch (e) {
              messenger.toastButton(e.toString(), () {
                ref.read(actionStateProvider.notifier).synchronizeList(
                    (_connectionStatus[0] != ConnectivityResult.none),);
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
            AppLogger.d("Mark done action.id: ${widget.action.id}");
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                (widget.action.importance != Importance.no)
                    ? Icon(
                        getImportanceIcon(widget.action.importance),
                        color: getImportanceColor(widget.action.importance),
                      )
                    : const SizedBox.shrink(),
                Flexible(
                  child: Text(
                    widget.action.text,
                    style: widget.action.done
                        ? theme.textTheme.bodyLarge?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          )
                        : theme.textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            widget.action.deadlineON
                ? Text(
                    formatter.format(widget.action.deadline),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          color: Colors.grey,
          onPressed: () {
            AppLogger.d(
              "Navigator push AddActionPage with action.id: ${widget.action.id}",
            );
            context.goNamed("task", pathParameters: {
              'id': widget.action.id,
            },);
          },
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
