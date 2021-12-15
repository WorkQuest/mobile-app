import 'package:app/model/profile_response/avatar.dart';

class Notifications {
  String firstName;
  String lastName;
  Avatar avatar;
  DateTime date;
  String idEvent;
  String idUser;
  String type;
  String message;

  Notifications({
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.date,
    required this.idEvent,
    required this.idUser,
    required this.type,
    required this.message,
  });
}
