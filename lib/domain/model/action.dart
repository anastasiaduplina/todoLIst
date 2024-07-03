class ActionToDo {
  String id;
  String text;
  bool done;
  bool deadlineON;
  DateTime deadline;
  Importance importance;
  String color;
  DateTime createdAt;
  DateTime changedAt;
  String lastUpdatedBy;

  ActionToDo(
    this.id,
    this.text,
    this.done,
    this.deadlineON,
    this.deadline,
    this.importance,
    this.color,
    this.createdAt,
    this.changedAt,
    this.lastUpdatedBy,
  );
}

enum Importance {
  no,
  low,
  high;

  const Importance();
}

ActionToDo getEmptyAction() {
  return ActionToDo(
    "",
    "",
    false,
    false,
    DateTime.now(),
    Importance.no,
    "",
    DateTime.now(),
    DateTime.now(),
    "1",
  );
}
