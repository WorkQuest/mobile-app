import 'package:app/http/api_provider.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part 'portfolio_store.g.dart';

@injectable
class PortfolioStore extends _PortfolioStore with _$PortfolioStore {
  PortfolioStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _PortfolioStore extends IStore<bool> with Store {
  final ApiProvider apiProvider;

  _PortfolioStore(this.apiProvider);

  @observable
  int pageNumber = 0;

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  ObservableList<DrishyaEntity> media = ObservableList();

  @action
  void changePageNumber(int value) => pageNumber = value;

  void setTitle(String value)=> title = value;

  void setDescription(String value)=> description = value;



  @action
  void removeImage(int index) => media.removeAt(index);

}
