import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../domain/model/action.dart';
import '../../../../utils/logger.dart';
import '../../../providers/action_provider.dart';
import '../../add_edit_action/add_action.dart';

class ActionTile extends ConsumerStatefulWidget {
  const ActionTile({
    super.key,
    required this.action,
    required this.eyeON,
  });

  final bool eyeON;
  final ActionToDo action;

  @override
  ConsumerState<ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends ConsumerState<ActionTile> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
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
          setState(() {
            ref
                .read(actionStateProvider.notifier)
                .markDoneOrNot(widget.action, true);
          });

          await ref
              .read(actionStateProvider.notifier)
              .markDoneOrNot(widget.action, widget.action.done);
          return false;
        } else if (direction == DismissDirection.endToStart) {
          return true;
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          AppLogger.d("Delete action.id: ${widget.action.id}");
          ref.read(actionStateProvider.notifier).deleteAction(widget.action);
        }
      },
      child: ListTile(
        key: Key(widget.action.id.toString()),
        titleAlignment: ListTileTitleAlignment.top,
        leading: Checkbox(
          activeColor: Colors.green,
          value: widget.action.done && widget.eyeON,
          side: BorderSide(
              color: getImportanceColor(widget.action.importance), width: 2),
          onChanged: (bool? value) {
            ref
                .read(actionStateProvider.notifier)
                .markDoneOrNot(widget.action, !widget.action.done);
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
                    style: (widget.action.done && widget.eyeON)
                        ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            )
                        : Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            widget.action.deadlineON
                ? Text(
                    formatter.format(widget.action.deadline),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
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
                "Navigator push AddActionPage with action.id: ${widget.action.id}");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddActionPage(widget.action),
                ));
          },
        ),
      ),
    );
  }
}
