import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';

abstract class IMyQuestRepository {
  Future setStar(BaseQuestResponse quest, bool starSet);

  Future<List<BaseQuestResponse>> getFavoritesQuests({int offset = 0});

  Future<List<BaseQuestResponse>> getEmployerQuests({required List<int> statuses, int offset = 0});

  Future<List<BaseQuestResponse>> getWorkerQuests({
    required List<int> statuses,
    required bool isResponded,
    required bool isInvited,
    int offset = 0,
  });
}

class MyQuestRepository extends IMyQuestRepository {
  MyQuestRepository(ApiProvider apiProvider) : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  @override
  Future<List<BaseQuestResponse>> getEmployerQuests({required List<int> statuses, int offset = 0}) async {
    try {
      return await _apiProvider.getEmployerQuests(
        offset: offset,
        sort: "sort[createdAt]=desc",
        statuses: statuses,
        me: true,
      );
    } catch (e) {
      print('MyQuestRepository getEmployerQuests | error: $e');
      throw MyQuestException(e.toString());
    }
  }

  @override
  Future<List<BaseQuestResponse>> getFavoritesQuests({int offset = 0}) async {
    try {
      return await _apiProvider.getQuests(
        offset: offset,
        sort: "sort[createdAt]=desc",
        starred: true,
      );
    } catch (e) {
      print('MyQuestRepository getFavoritesQuests | error: $e');
      throw MyQuestException(e.toString());
    }
  }

  @override
  Future<List<BaseQuestResponse>> getWorkerQuests({
    required List<int> statuses,
    required bool isResponded,
    required bool isInvited,
    int offset = 0,
  }) async {
    try {
      return await _apiProvider.getWorkerQuests(
        offset: offset,
        sort: "sort[createdAt]=desc",
        responded: isResponded,
        invited: isInvited,
        statuses: statuses,
        me: true,
      );
    } catch (e) {
      print('MyQuestRepository getWorkerQuests | error: $e');
      throw MyQuestException(e.toString());
    }
  }

  @override
  Future setStar(BaseQuestResponse quest, bool starSet) async {
    try {
      if (starSet)
        await _apiProvider.setStar(id: quest.id);
      else
        await _apiProvider.removeStar(id: quest.id);
    } catch (e) {
      print('MyQuestRepository setStar | error: $e');
      throw MyQuestException(e.toString());
    }
  }
}

class MyQuestException implements Exception {
  final String message;

  MyQuestException([this.message = 'Unknown my quest error']);

  @override
  String toString() => message;
}
