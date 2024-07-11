class ServerErrorException implements Exception {
  final String msg;

  const ServerErrorException(this.msg);

  @override
  String toString() => 'Something go wrong: $msg';
}
