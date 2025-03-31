import 'package:animexhub/models/ani_pic.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Anipicservice {
  static const String _baseUrl =
      "https://api.nekosapi.com/v4/images/random";
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<AniPic>> fetchAniPics({
    required int limit,
    List<Rating> rating = const [],
    List<String> tags = const [],
  }) async {
    try {
      final response = await dio.get(
        _baseUrl,
        queryParameters: {
          'limit': limit,
          if (rating.isNotEmpty)
            'rating': rating.map((r) => r.value).join(','),
          if (tags.isNotEmpty) 'tags': tags.join(','),
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData
            .map((aniPic) => AniPic.fromJson(aniPic))
            .toList();
      } else {
        debugPrint("Failed to load ani pics");
        throw Exception('Failed to load ani pics');
      }
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception('Failed to load ani pics');
    }
  }
}
