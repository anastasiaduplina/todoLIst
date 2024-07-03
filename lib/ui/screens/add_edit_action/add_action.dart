import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/ui/providers/action_provider.dart';
import 'package:todo_list_app/utils/logger.dart';

import '../../../domain/model/action.dart';

class AddActionPage extends ConsumerStatefulWidget {
  const AddActionPage(this.action, {super.key});

  final ActionToDo action;

  @override
  AddActionPageState createState() => AddActionPageState();
}

class AddActionPageState extends ConsumerState<AddActionPage> {
  late TextEditingController textController;
  late ActionToDo action;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.action.text);
    action = widget.action;
  }

  void setPickedDate() async {
    if (!action.deadlineON) {
      return;
    }

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
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final DateFormat formatter =
        DateFormat('dd MMMM yyyy', AppLocalizations.of(context).localeName);
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
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              AppLogger.d("Save action.id: ${action.id}");
              action.text = textController.text;
              ref.read(actionStateProvider.notifier).addOrEditAction(action);
              AppLogger.d("Navigator pop from AddActionPage");
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context).save,
              style: theme.textTheme.titleSmall?.copyWith(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
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
                        getImportanceString(Importance.values[index], context),
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
                  onPressed: () => setPickedDate(),
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
              onPressed: () {
                AppLogger.d("Delete action.id: ${action.id}");
                ref.read(actionStateProvider.notifier).deleteAction(action);
                AppLogger.d("Navigator pop from AddActionPage");
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              label: Text(
                AppLocalizations.of(context).delete,
                style: theme.textTheme.labelLarge?.copyWith(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
