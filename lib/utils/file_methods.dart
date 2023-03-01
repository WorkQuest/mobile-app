import '../model/media_model.dart';

class FileUtils {
  static TypeFile getTypeFile(String filePath) {
    final _formatFile = filePath.split('.').last.toLowerCase();
    if (_formatFile == 'jpeg' ||
        _formatFile == 'jpg' ||
        _formatFile == 'png' ||
        _formatFile == 'webp') {
      return TypeFile.image;
    }
    if (_formatFile == 'mp4' || _formatFile == 'mov') {
      return TypeFile.video;
    }
    if (_formatFile == 'pdf' || _formatFile == 'doc' || _formatFile == 'docx') {
      return TypeFile.documents;
    }
    return TypeFile.unknown;
  }

  static TypeFile getTypeFileFromTypeMedia(TypeMedia type) {
    switch (type) {
      case TypeMedia.Image:
        return TypeFile.image;
      case TypeMedia.Video:
        return TypeFile.video;
      case TypeMedia.Pdf:
        return TypeFile.documents;
      case TypeMedia.Doc:
        return TypeFile.documents;
    }
  }
}

enum TypeFile { image, video, documents, unknown }
