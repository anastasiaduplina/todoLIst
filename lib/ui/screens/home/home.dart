import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/ui/providers/action_provider.dart';
import 'package:todo_list_app/ui/screens/home/widgets/action_list_tile.dart';
import 'package:todo_list_app/utils/logger.dart';

import '../../../domain/model/action.dart';
import '../add_edit_action/add_action.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends ConsumerState<MyHomePage> {
  late bool eyeON;
  late TextEditingController textController;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    eyeON = true;
    textController = TextEditingController(text: "");
  }

  int countDoneActions(List<ActionToDo> list) {
    int count = list.where((item) => item.done).length;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    List<ActionToDo> items = ref.watch(actionStateProvider).valueOrNull ?? [];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(controller: scrollController, slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          snap: false,
          floating: false,
          expandedHeight: 160,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shadowColor: Theme.of(context).shadowColor,
          surfaceTintColor: Theme.of(context).cardColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Мои дела',
                  style: Theme.of(context).textTheme.headlineMedium,
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
              child: Text('Выполнено - ${countDoneActions(items)}'),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.5),
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
                        return ActionTile(action: items[index], eyeON: eyeON);
                      }),
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 32.0, right: 32, bottom: 128),
                        child: TextFormField(
                            controller: textController,
                            maxLines: 3,
                            minLines: 1,
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            onTap: () {
                              // todo быстрое добавление
                              //  пока перекидывает на обычную страницу добавления
                              AppLogger.d("Push AddAction Page");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddActionPage(getEmptyAction()),
                                  ));
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: "Новое")),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom + 20),
                ],
              ),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          AppLogger.d("Push AddAction Page");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddActionPage(getEmptyAction()),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
