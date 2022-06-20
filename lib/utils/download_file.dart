import 'dart:io';

import 'package:flutter/foundation.dart';

class DownloadFile {
  Future<String> downloadFile(
    String url,
    String fileName,
    String directory,
  ) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$directory/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }
    return filePath;
  }
}
