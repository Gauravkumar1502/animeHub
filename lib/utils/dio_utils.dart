import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
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
}
