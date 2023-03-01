import 'package:app/model/chat_model/message_model.dart';

class DeletionData {
  DeletionData({
    required this.id,
    required this.message,
  });

  String id;
  MessageModel message;

  factory DeletionData.fromJson(Map<String, dynamic> json) => DeletionData(
        id: json["id"],
        message: MessageModel.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message.toJson(),
      };
}
