import 'dart:io';

import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/media_model.dart';
import 'package:path_provider/path_provider.dart';

import 'download_file.dart';

class Thumbnail {
  Future<Map<Media, String>> getThumbnail(List<MessageModel> messages) async {
    Map<Media, String> mediaPaths = {};
    for (int i = 0; i < messages.length; i++) {
      for (int j = 0; j < messages[i].medias.length; j++) {
        if (messages[i].medias[j].type == TypeMedia.Video) {
          String dir = "";
          if (Platform.isAndroid) {
            dir = (await getExternalStorageDirectory())!.path;
          } else if (Platform.isIOS) {
            dir = (await getApplicationDocumentsDirectory()).path;
          }
          var existsFile = await File(dir +
                  "/" +
                  "${messages[i].medias[j].url.split("/").reversed.first}.mp4")
              .exists();
          if (!existsFile) {
            final f = await DownloadFile().downloadFile(
                messages[i].medias[j].url,
                messages[i].medias[j].url.split("/").reversed.first + ".mp4",
                dir);
            mediaPaths[messages[i].medias[j]] = f;
          } else
            mediaPaths[messages[i].medias[j]] = dir +
                "/" +
                "${messages[i].medias[j].url.split("/").reversed.first}.mp4";
        }
      }
    }
    return mediaPaths;
  }
}
