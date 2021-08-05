import 'package:app/http/api_provider.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/model/create_quest_model/create_quest_request_model.dart';
import 'package:app/model/quests_models/create_quest_model/location_model.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'create_quest_store.g.dart';

@injectable
class CreateQuestStore extends _CreateQuestStore with _$CreateQuestStore {
  CreateQuestStore(ApiProvider questApiProvider) : super(questApiProvider);
}

abstract class _CreateQuestStore extends IStore<bool> with Store {
  final ApiProvider apiProvider;

  _CreateQuestStore(this.apiProvider);

  final List<String> questCategoriesList = [
    "Retail / sales / purchasing",
    "Transport / logistics / Construction",
    "Telecommunications / Communication",
    "Bars / restaurants",
    "Law and accounting",
    "Personnel management / HR",
    "Security / safety",
    "Home staff",
    "Beauty / fitness / sport",
    "Tourism / Leisure / Entertainment",
    "Education",
    "Culture / Arts",
    "Medicine / Pharmacy",
    " IT / Telecom / Computers",
    " Banking / Finance / Insurance",
    "Real Estate",
    "Marketing / Advertising",
    "Design / layout design",
    "Interior and exterior design / 3D visualization",
    "Production / energy",
    "Agriculture / agribusiness / forestry",
    "Secretariat / document management",
    "Early career / Students",
    "Service and life",
    "Work abroad",
    "Seasonal work",
    "Other areas of employment"
  ];

  final List<String> priorityList = [
    "Choose",
    "Low",
    "Normal",
    "Urgent",
  ];

  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// location, runtime, images and videos ,priority undone

  @observable
  String category = 'Choose';

  @observable
  String categoryValue = 'other';

  @observable
  String priority = 'Choose';

  @observable
  int priorityInt = 0;

  @observable
  bool hasRuntime = false;

  @observable
  DateTime runtimeValue = DateTime.now().add(
    Duration(days: 1),
  );

  @observable
  String dateTime = '';

  @observable
  double longitude = 0;

  @observable
  double latitude = 0;

  @observable
  String questTitle = '';

  @observable
  String description = '';

  @observable
  String price = '';

  @observable
  int adType = 0;

  @observable
  ObservableList<DrishyaEntity> media = ObservableList();

  /// change location data

  @action
  void setQuestTitle(String value) => questTitle = value;

  @action
  void setRuntime(bool? value) => hasRuntime = value!;

  @computed
  String get dateString =>
      "${runtimeValue.year.toString()} - "
          "${months[runtimeValue.month - 1].padLeft(2, '0')} - "
          "${runtimeValue.day.toString().padLeft(2, '0')} ";

  @action
  void setDateTime(DateTime value) => runtimeValue = value ;

  @action
  void removeImage(int index) => media.removeAt(index);

  @action
  void setAboutQuest(String value) => description = value;

  @action
  void setPrice(String value) => price = value;

  @action
  void changedCategory(String selectedCategory) {
    category = selectedCategory;
    switch (category) {
      case "Retail / sales / purchasing":
        categoryValue = "retail";
        break;
      case "Transport / logistics / Construction":
        categoryValue = "transport";
        break;
      case "Telecommunications / Communication":
        categoryValue = "communication";
        break;
      case "Bars / restaurants":
        categoryValue = "bar";
        break;
      case "Law and accounting":
        categoryValue = "law";
        break;
      case "Personnel management / HR":
        categoryValue = "hr";
        break;
      case "Security / safety":
        categoryValue = "security";
        break;
      case "Home staff":
        categoryValue = "home";
        break;
      case "Beauty / fitness / sport":
        categoryValue = "beauty";
        break;
      case "Tourism / Leisure / Entertainment":
        categoryValue = "entertainment";
        break;
      case "Education":
        categoryValue = "education";
        break;
      case "Culture / Arts":
        categoryValue = "culture";
        break;
      case "Medicine / Pharmacy":
        categoryValue = "medicine";
        break;
      case "IT / Telecom / Computers":
        categoryValue = "it";
        break;
      case "Banking / Finance / Insurance":
        categoryValue = "banking";
        break;
      case "Real Estate":
        categoryValue = "realEstate";
        break;
      case "Marketing / Advertising":
        categoryValue = "marketing";
        break;
      case "Design / layout design":
        categoryValue = "design";
        break;
      case "Interior and exterior design / 3D visualization":
        categoryValue = "design3D";
        break;
      case "Production / energy":
        categoryValue = "production";
        break;
      case "Agriculture / agribusiness / forestry":
        categoryValue = "agriculture";
        break;
      case "Secretariat / document management":
        categoryValue = "secretariat";
        break;
      case "Early career / Students":
        categoryValue = "earlyCareer";
        break;
      case "Service and life":
        categoryValue = "service";
        break;
      case "Work abroad":
        categoryValue = "abroad";
        break;
      case "Seasonal work":
        categoryValue = "seasonal";
        break;
      case "Other areas of employment":
        categoryValue = "other";
        break;
    }
  }

  @action
  void changedPriority(String selectedPriority) {
    priority = selectedPriority;
    priorityInt = priorityList.indexOf(priority);
  }

  @computed
  bool get canCreateQuest =>
      !isLoading && priority.isNotEmpty && category.isNotEmpty;

  @action
  Future createQuest() async {
    await apiProvider.uploadMedia(medias: media);
    try {
      this.onLoading();
      final Location location = Location(
        longitude: longitude,
        latitude: latitude,
      );
      final CreateQuestRequestModel questModel = CreateQuestRequestModel(
        category: categoryValue,
        priority: priorityInt,
        location: location,
        media: media,
        title: questTitle,
        description: description,
        price: price,
        adType: adType,
      );
      await apiProvider.createQuest(quest: questModel);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
