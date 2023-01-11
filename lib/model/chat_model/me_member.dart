class MeMember {
  MeMember({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.lastReadMessageId,
    required this.unreadCountMessages,
    required this.lastReadMessageNumber,
  });

  String id;
  String chatId;
  String userId;
  String? lastReadMessageId;
  int unreadCountMessages;
  int lastReadMessageNumber;

  factory MeMember.fromJson(Map<String, dynamic> json) => MeMember(
        id: json["id"],
        chatId: json["chatId"],
        userId: json["userId"],
        lastReadMessageId: json["lastReadMessageId"] == null
            ? null
            : json["lastReadMessageId"],
        unreadCountMessages: json["unreadCountMessages"],
        lastReadMessageNumber: json["lastReadMessageNumber"] == null
            ? 0
            : json["lastReadMessageNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chatId": chatId,
        "userId": userId,
        "lastReadMessageId": lastReadMessageId,
        "unreadCountMessages": unreadCountMessages,
        "lastReadMessageNumber": lastReadMessageNumber,
      };
}
