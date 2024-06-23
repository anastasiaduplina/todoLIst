import 'package:flutter/material.dart';
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
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  late TextEditingController textController;
  late ActionToDo action;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.action.text);
    action = widget.action;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).cardColor,
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
                AppLogger.d("Save action.id: ${widget.action.id}");
                action.text = textController.text;
                ref.read(actionStateProvider.notifier).addOrEditAction(action);
                AppLogger.d("Navigator pop from AddActionPage");
                Navigator.pop(context);
              },
              child: Text("Сохранить",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.blue)))
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
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Что надо сделать..."),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Важность",
                    style: Theme.of(context).textTheme.titleMedium),
                MenuAnchor(
                  style: MenuStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).cardColor),
                    surfaceTintColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).cardColor),
                  ),
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return TextButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      child: Text(action.importance.value,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.grey)),
                    );
                  },
                  menuChildren: List<MenuItemButton>.generate(
                    3,
                    (int index) => MenuItemButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).cardColor),
                      ),
                      onPressed: () {
                        AppLogger.d(
                            "Change importance of action.id: ${widget.action.id} to ${Importance.values[index]}");
                        setState(
                            () => action.importance = Importance.values[index]);
                      },
                      child: Text(
                        Importance.values[index].value,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: (Importance.values[index] == Importance.high)
                                ? Colors.red
                                : Colors.grey),
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
                Text("Сделать до",
                    style: Theme.of(context).textTheme.titleMedium),
                TextButton(
                  child: action.deadlineON
                      ? Text(
                          formatter.format(action.deadline),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.blue),
                        )
                      : const Text(""),
                  onPressed: () async {
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
                          "Change deadline of action.id: ${widget.action.id} to $pickedDate");
                      setState(() {
                        action.deadline = pickedDate;
                      });
                    } else {}
                  },
                ),
                Switch(
                    value: action.deadlineON,
                    activeColor: Colors.blue,
                    onChanged: (bool value) {
                      AppLogger.d(
                          "Change deadlineON of action.id: ${widget.action.id} to $value");
                      setState(() {
                        action.deadlineON = value;
                      });
                    }),
              ],
            ),
            const Divider(),
            TextButton.icon(
              onPressed: () {
                AppLogger.d("Delete action.id: ${widget.action.id}");
                ref.read(actionStateProvider.notifier).deleteAction(action);
                AppLogger.d("Navigator pop from AddActionPage");
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              label: Text('Удалить',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
