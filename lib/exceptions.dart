class RequestErrorModel implements Exception {
  final String message;
  final int errorCode;

  const RequestErrorModel({
    required this.message,
    required this.errorCode,
  });

  @override
  factory RequestErrorModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      RequestErrorModel(
        errorCode: json["code"],
        message: json["msg"],
      );

  @override
  String toString() {
    return this.message;
  }

  int returnErrorCode() {
    return this.errorCode;
  }
}
