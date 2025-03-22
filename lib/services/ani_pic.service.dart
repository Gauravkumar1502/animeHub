import 'dart:convert';

import 'package:animexhub/models/ani_pic.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Anipicservice {
  final String _baseUrl =
      "https://api.nekosapi.com/v4/images/random";

  Future<List<AniPic>> fetchAniPics({
    required int limit,
    // Array of strings [safe, suggestive, borderline, explicit]
    List<Rating> rating = const [],
    List<String> tags = const [],
  }) async {
    String url = '$_baseUrl?limit=$limit';
    if (rating.isNotEmpty) {
      url +=
          '&rating=${rating.map((r) => r.value).join(',')}';
    }
    if (tags.isNotEmpty) {
      url += '&tags=${tags.join(',')}';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(
        response.body,
      );
      debugPrint("url: $url");
      return jsonData
          .map((aniPic) => AniPic.fromJson(aniPic))
          .toList();
    } else {
      debugPrint("Failed to load ani pics");
      throw Exception('Failed to load ani pics');
    }
  }
}
