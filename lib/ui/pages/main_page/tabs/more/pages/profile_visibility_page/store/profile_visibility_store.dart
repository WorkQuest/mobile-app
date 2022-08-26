import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';


part 'profile_visibility_store.g.dart';

@injectable
class ProfileVisibilityStore extends _ProfileVisibilityStore
    with _$ProfileVisibilityStore {
  ProfileVisibilityStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ProfileVisibilityStore extends IStore<bool> with Store {
  final ApiProvider apiProvider;

  _ProfileVisibilityStore(this.apiProvider);

  init(ProfileMeResponse profile) {
    List<int> _mySearchVisibility = profile.getMySearchVisibilityList();
    List<int> _canRespondOrInviteToQuestVisibility =
        profile.getCanInviteOrRespondMeOnQuest();

    _mySearchVisibility.map((value) {
      final _type = _getVisibilityType(value);
      setMySearch(_type, true);
    }).toList();

    _canRespondOrInviteToQuestVisibility.map((type) {
      final _type = _getVisibilityType(type);
      setCanRespondOrInviteToQuest(_type, true);
    }).toList();
  }

  @observable
  ObservableMap<VisibilityTypes, bool> mySearch = ObservableMap.of({
    VisibilityTypes.topRanked: false,
    VisibilityTypes.reliable: false,
    VisibilityTypes.verified: false,
    VisibilityTypes.notRated: false,
  });

  @observable
  ObservableMap<VisibilityTypes, bool> canRespondOrInviteToQuest =
      ObservableMap.of({
    VisibilityTypes.topRanked: false,
    VisibilityTypes.reliable: false,
    VisibilityTypes.verified: false,
    VisibilityTypes.notRated: false,
  });

  @action
  setMySearch(VisibilityTypes type, bool value) {
    mySearch[type] = value;
  }

  @action
  setCanRespondOrInviteToQuest(VisibilityTypes type, bool value) {
    canRespondOrInviteToQuest[type] = value;
  }

  @action
  editProfileVisibility(ProfileMeResponse profile) async {
    try {
      onLoading();
      profile.workerOrEmployerProfileVisibilitySetting =
          WorkerProfileVisibilitySettingClass(
        arrayRatingStatusCanInviteMeOnQuest:
            _getVisibilityListValueType(canRespondOrInviteToQuest),
        arrayRatingStatusCanRespondToQuest:
            _getVisibilityListValueType(canRespondOrInviteToQuest),
        arrayRatingStatusInMySearch: _getVisibilityListValueType(mySearch),
      );
      await apiProvider.changeProfileMe(profile);
      onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }

  VisibilityTypes _getVisibilityType(int value) {
    if (value == 2) {
      return VisibilityTypes.verified;
    } else if (value == 4) {
      return VisibilityTypes.reliable;
    } else if (value == 8) {
      return VisibilityTypes.topRanked;
    } else if (value == 1) {
      return VisibilityTypes.notRated;
    } else {
      throw FormatException('Unknown Visibility Value Type');
    }
  }

  List<int> _getVisibilityListValueType(Map<VisibilityTypes, bool> map) {
    List<int> _result = [];
    map.forEach((key, value) {
      if (map[key]!) {
        _result.add(_getVisibilityValueType(key));
      }
    });
    return _result;
  }

  int _getVisibilityValueType(VisibilityTypes type) {
    if (type == VisibilityTypes.topRanked) {
      return 8;
    } else if (type == VisibilityTypes.verified) {
      return 2;
    } else if (type == VisibilityTypes.reliable) {
      return 4;
    } else if (type == VisibilityTypes.notRated) {
      return 1;
    } else {
      throw FormatException('Unknown Visibility Type');
    }
  }
}

enum VisibilityTypes { topRanked, reliable, verified, notRated }
