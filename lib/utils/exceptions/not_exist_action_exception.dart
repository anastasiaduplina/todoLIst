class NotExistActionException implements Exception {
  final String msg;

  const NotExistActionException(this.msg);

  @override
  String toString() => 'There is not task: $msg';
}
