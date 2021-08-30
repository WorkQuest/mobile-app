import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'dispute_store.g.dart';

@injectable
class DisputeStore = _DisputeStore with _$DisputeStore;

abstract class _DisputeStore with Store {
  final List<String> disputeCategoriesList = [
    "There is no response from the employer / employee",
    "Badly done work",
    "Additional requirements have been put forward",
    "Inconsistencies in the requirements for the description of the quest",
    "The quest is completed but the employee / employer has not confirmed its completion",
    "Another reason"
  ];

  @observable
  String theme = 'Dispute Theme';

  @observable
  String themeValue = '';

  @observable
  String description = '';

  @action
  void setDescription(String value) => description = value;

  @action
  void changeTheme(String selectTheme) {
    theme = selectTheme;
    switch (theme) {
      case "There is no response from the employer / employee":
        themeValue = "There is no response from the employer / employee";
        break;
      case "Badly done work":
        themeValue = "Badly done work";
        break;
      case "Additional requirements have been put forward":
        themeValue = "Additional requirements have been put forward";
        break;
      case "Inconsistencies in the requirements for the description of the quest":
        themeValue =
            "Inconsistencies in the requirements for the description of the quest";
        break;
      case "The quest is completed but the employee / employer has not confirmed its completion":
        themeValue = "The quest is completed but the employee / employer has not confirmed its completion";
        break;
      case "Another reason":
        themeValue = "Another reason";
        break;
      default:
        themeValue = "Placeholder";
    }
  }
}
