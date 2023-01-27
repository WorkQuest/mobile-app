import 'package:app/ui/pages/report_page/report_page.dart';
import 'package:app/ui/widgets/media_upload/store/i_media_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../../../http/api_provider.dart';

part 'report_store.g.dart';

@injectable
class ReportStore extends _ReportStore with _$ReportStore {
  ReportStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ReportStore extends IMediaStore<bool> with Store {
  final ApiProvider _apiProvider;

  _ReportStore(this._apiProvider);

  @action
  sendReport({
    required ReportEntityType entityType,
    required String entityId,
    required String title,
    required String description,
  }) async {
    try {
      onLoading();
      await sendImages(_apiProvider);
      await _apiProvider.sendReport(
        entityType: _getEntityType(entityType),
        entityId: entityId,
        title: title,
        description: description,
        mediaIds: medias.map((media) => media.id).toList(),
      );
      onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }

  _getEntityType(ReportEntityType entityType) {
    switch (entityType) {
      case ReportEntityType.user:
        return 'User';
      case ReportEntityType.quest:
        return 'Quest';
      case ReportEntityType.discussionComment:
        return 'DiscussionComment';
    }
  }
}
