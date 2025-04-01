import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/adapters.dart';

part 'ani_pic.g.dart';

@HiveType(typeId: 0)
enum Rating {
  @HiveField(0)
  safe("safe"),
  @HiveField(1)
  suggestive("suggestive"),
  @HiveField(2)
  borderline("borderline"),
  @HiveField(3)
  explicit("explicit");

  final String value;
  const Rating(this.value);
}

@immutable
@HiveType(typeId: 1)
class AniPic {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String url;
  @HiveField(2)
  final Rating rating;
  @HiveField(3)
  final List<String> tags;

  const AniPic({
    required this.id,
    required this.url,
    required this.rating,
    required this.tags,
  });

  factory AniPic.fromJson(Map<String, dynamic> json) {
    return AniPic(
      id: json['id'],
      url: json['url'],
      rating: Rating.values.firstWhere(
        (r) => r.value == json['rating'],
      ),
      tags: List<String>.from(json['tags']),
    );
  }

  @override
  String toString() {
    return 'AniPic{id: $id, url: $url, rating: $rating, tags: $tags}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AniPic &&
        other.id == id &&
        other.url == url &&
        other.rating == rating &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        url.hashCode ^
        rating.hashCode ^
        tags.hashCode;
  }
}
