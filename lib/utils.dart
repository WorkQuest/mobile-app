import 'package:app/enums.dart';

class Utils {
  static String getUserRoleString(UserRole userRole) {
    if (userRole == UserRole.Worker) {
      return "Worker";
    } else {
      return "Employer";
    }
  }
}
