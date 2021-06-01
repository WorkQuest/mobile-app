import 'package:app/http/core/i_http_client.dart';
import 'package:app/model/bearer_token/bearer_token.dart';
import 'package:injectable/injectable.dart';

@singleton
class QuestApiProvider {
  final IHttpClient _httpClient;
  QuestApiProvider(this._httpClient);
}

extension QuestService on QuestApiProvider{

  Future<void> createQuest({
    required Map<String, dynamic> quest,
  }) async {

    final responseData = await _httpClient.post(
      query: '/v1/quest/create',
      data: quest,
    );

    _httpClient.bearerToken = BearerToken.fromJson(
      responseData["data"],
    );
  }
}