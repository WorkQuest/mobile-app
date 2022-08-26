import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/entity/filter_arguments.dart';

abstract class ISearchRepository {
  Future<List<ProfileMeResponse>> getWorkers({
    required FilterArguments filters,
    required UserRole role,
    String searchWord = '',
    int offset = 0,
  });

  Future<List<BaseQuestResponse>> getQuests({
    required FilterArguments filters,
    required UserRole role,
    String searchWord = '',
    int offset = 0,
  });
}

class SearchRepository extends ISearchRepository {
  SearchRepository(ApiProvider apiProvider) : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  @override
  Future<List<BaseQuestResponse>> getQuests({
    required FilterArguments filters,
    required UserRole role,
    String searchWord = '',
    int offset = 0,
  }) async {
    try {
      return await _apiProvider.getQuests(
        price: filters.getFilterPrice(role),
        searchWord: searchWord,
        offset: offset,
        employment: filters.employments,
        workplace: filters.workplaces,
        priority: filters.priorities,
        payPeriod: filters.payPeriod,
        sort: filters.sort,
        specializations: filters.selectedSkill,
        statuses: [1],
      );
    } catch (e) {
      print('SearchRepository getQuests | error: $e');
      throw SearchException(e.toString());
    }
  }

  @override
  Future<List<ProfileMeResponse>> getWorkers({
    required FilterArguments filters,
    required UserRole role,
    String searchWord = '',
    int offset = 0,
  }) async {
    try {
      return await _apiProvider.getWorkers(
        sort: filters.sort,
        price: filters.getFilterPrice(role),
        offset: offset,
        workplace: filters.workplaces,
        payPeriod: filters.payPeriod,
        priority: filters.priorities,
        ratingStatus: filters.employeeRatings,
        specializations: filters.selectedSkill,
      );
    } catch (e) {
      print('SearchRepository getWorkers | error: $e');
      throw SearchException(e.toString());
    }
  }
}

class SearchException implements Exception {
  final String message;

  SearchException([this.message = 'Unknown search error']);

  @override
  String toString() => message;
}
