class CoreException implements Exception {
  dynamic message;

  int get code => 500;

  CoreException(this.message);

  @override
  String toString() {
    return '${this.message}';
  }
}
