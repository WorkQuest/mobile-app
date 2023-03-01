class ChatMemberData {
  ChatMemberData({
    required this.lastReadMessageId,
    required this.unreadCountMessages,
    required this.lastReadMessageNumber,
  });

  String? lastReadMessageId;
  int unreadCountMessages;
  int? lastReadMessageNumber;

  factory ChatMemberData.fromJson(Map<String, dynamic> json) => ChatMemberData(
        lastReadMessageId: json["lastReadMessageId"] == null
            ? null
            : json["lastReadMessageId"],
        unreadCountMessages: json["unreadCountMessages"],
        lastReadMessageNumber: json["lastReadMessageNumber"] == null
            ? null
            : json["lastReadMessageNumber"],
      );

  Map<String, dynamic> toJson() => {
        "lastReadMessageId":
            lastReadMessageId == null ? null : lastReadMessageId,
        "unreadCountMessages": unreadCountMessages,
        "lastReadMessageNumber":
            lastReadMessageNumber == null ? null : lastReadMessageNumber,
      };
}
