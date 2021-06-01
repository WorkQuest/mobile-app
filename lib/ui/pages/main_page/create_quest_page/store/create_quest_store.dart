import 'package:app/http/quest_api_provider.dart';
import 'package:app/model/quest_model/quest_model.dart';
import 'package:app/base_store/i_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'create_quest_store.g.dart';

@injectable
class CreateQuestStore extends _CreateQuestStore with _$CreateQuestStore {
  CreateQuestStore(QuestApiProvider questApiProvider) : super(questApiProvider);
}

abstract class _CreateQuestStore extends IStore<bool> with Store {
  final QuestApiProvider questApiProvider;

  _CreateQuestStore(this.questApiProvider);

  List<String> questCategoriesList = [
    "Choose",
    "Retail / sales / purchasing",
    "Transport / logistics / Construction",
    "Telecommunications / Communication",
    "Bars / restaurants ",
    "Law and accounting ",
    "Personnel management / HR",
    "Security / safety ",
    "Home staff",
    "Beauty / fitness / sport ",
    "Tourism / Leisure / Entertainment",
    "Education",
    "Culture / Arts",
    "Medicine / Pharmacy",
    " IT / Telecom / Computers",
    " Banking / Finance / Insurance",
    "Real Estate ",
    "Marketing / Advertising ",
    "Design / layout design",
    "Interior and exterior design / 3D visualization",
    "Production / energy ",
    "Agriculture / agribusiness / forestry ",
    "Secretariat / document management",
    "Early career / Students",
    "Service and life",
    "Work abroad",
    "Seasonal work",
    "Other areas of employment"
  ];


/// location, runtime, images and videos ,priority undone


  @observable
  String category = 'Choose';

  @observable
  int priority = 0;

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
/// change location data
  get location => null;

  @action
  void setQuestTitle(String value) => questTitle = value;

  @action
  void setAboutQuest(String value) => description = value;

  @action
  void setPrice(String value) => price = value;

  @action
  void changedDropDownItem(String selectedCategory) =>
      category = selectedCategory;

  @action
  Future createQuest() async {
    try {
      final QuestModel questModel = QuestModel(
          category: category,
          priority: priority,
          ///location data needed
          location: location,

          title: questTitle,
          description: description,
          price: price,
          adType: adType);
      await questApiProvider.createQuest(quest: questModel.toJson());
      this.onSuccess(true);
    } catch (e) {}
  }
}
