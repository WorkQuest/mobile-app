class InfoMessage {
  InfoMessage({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.messageAction,
    required this.user,
  });

  String? id;
  String messageId;
  String? userId;
  String messageAction;
  dynamic user;

  factory InfoMessage.fromJson(Map<String, dynamic> json) => InfoMessage(
        id: json["json"],
        messageId: json["messageId"],
        userId: json["userId"],
        messageAction: json["messageAction"],
        user: json["user"],
      );
}
