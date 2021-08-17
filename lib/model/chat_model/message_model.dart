class MessageModel {
  String id;
  String senderUserId;
  bool isMy;
  String chatId;
  String text;
  DateTime createdAt;
  DateTime updatedAt;
  MessageStatus status;
  List<String> medias;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.isMy,
    required this.text,
    required this.senderUserId,
    required this.updatedAt,
    required this.createdAt,
    required this.medias,
    this.status = MessageStatus.None,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"] ?? "",
        chatId: json["chatId"] ?? "",
        text: json["text"],
        senderUserId: json["senderUserId"],
        isMy: true,
        updatedAt: DateTime.parse(json['updatedAt'] ?? json['createdAt'])
            .add(Duration(hours: 7)),
        createdAt: DateTime.parse(json['createdAt']).add(Duration(hours: 7)),
        medias: [],
      );
}

enum MessageStatus { None, Wait, Send, Error }
