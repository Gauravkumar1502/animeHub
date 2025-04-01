import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static final Dio _dio = Dio();

  /// Download file and return file path
  static Future<String> downloadFile(
    String url, {
    String? fileName,
    Directory? savePath,
  }) async {
    try {
      final tempDir = savePath ?? await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/${fileName ?? _getFileName(url)}';
      await _dio.download(url, filePath);
      return filePath;
    } catch (e) {
      throw Exception("Error downloading file: $e");
    }
  }

  /// Download file and return bytes
  static Future<Uint8List> getFileBytes(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data);
    } catch (e) {
      throw Exception("Error fetching file bytes: $e");
    }
  }

  /// Extract file name from URL
  static String _getFileName(String url) {
    return url.split('/').last;
  }

  static Future<String> getPicturesDirectory() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final picturesDir = Directory('${directory.path}/Pictures');
        if (!await picturesDir.exists()) {
          await picturesDir.create(recursive: true);
        }
        return picturesDir.path;
      } else {
        throw Exception("No external storage directory found");
      }
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}/Pictures';
    } else {
      throw Exception("Unsupported platform");
    }
  }

  static Future<bool> saveFileToGallery(
    String url,
    String fileName,
  ) async {
    var appDocDir = await getExternalStorageDirectory();
    if (appDocDir == null) {
      throw Exception("No external storage directory found");
    }
    String savePath = "${appDocDir.path}/$fileName";
    var downloadFile = await Dio().download(url, savePath);
    if (downloadFile.statusCode != 200) {
      throw Exception(
        "Error downloading file: ${downloadFile.statusCode}",
      );
    }
    // Save to gallery
    final result = await ImageGallerySaverPlus.saveFile(
      savePath,
      isReturnPathOfIOS: true,
    );
    return result['isSuccess'] == true
        ? true
        : throw Exception(
          "Error saving file to gallery: ${result['error']}",
        );
  }
}
