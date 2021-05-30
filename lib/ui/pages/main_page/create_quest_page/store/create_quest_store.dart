import 'package:mobx/mobx.dart';

part 'create_quest_store.g.dart';

class CreateQuestStore = _CreateQuestStore with _$CreateQuestStore;

abstract class _CreateQuestStore with Store {
  Map<String, int> queryParameters = {'page': 1};

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

  @observable
  String category ='Choose' ;

  @observable
  int  priority = 0;

  @observable
  double  longitude = 0;

  @observable
  double  latitude = 0;

  @observable
  String title ='';

  @observable
  String description ='';

  @observable
  String price ='';

  @observable
  int  adType = 0;

  @action
  void changedDropDownItem(String selectedCategory) {
    category = selectedCategory;
  }
}
