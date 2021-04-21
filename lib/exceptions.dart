class RequestError implements Exception {
  final String message;

  const RequestError({required this.message});

  @override
  String toString() {
    return this.message;
  }
}
