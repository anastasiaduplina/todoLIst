class NotValidRevisionException implements Exception {
  final String msg;

  const NotValidRevisionException(this.msg);

  @override
  String toString() => 'Current revision is not actual: $msg';
}
