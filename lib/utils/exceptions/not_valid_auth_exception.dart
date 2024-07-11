class NotValidAuthException implements Exception {
  final String msg;

  const NotValidAuthException(this.msg);

  @override
  String toString() => 'Something go wrong with authorization: $msg';
}
