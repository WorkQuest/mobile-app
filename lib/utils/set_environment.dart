import 'package:injectable/injectable.dart';
import '../enums.dart';

@injectable
@singleton
class SetEnvironment {

  ///True if worker
  ///false if emloyer

   late bool isWorker ;

  initEnvironment(UserRole userRole) {
    if (userRole == UserRole.Worker) {
      isWorker = true;
    } else
      isWorker = false;
    // switch (userRole) {
    //   case UserRole.Worker:
    //     return isWorker = true;
    //   default:
    //     return isWorker = false;
    // }
  }
}
