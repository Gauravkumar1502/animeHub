import 'package:animexhub/models/ani_pic.dart';
import 'package:animexhub/services/ani_pic.service.dart';
import 'package:animexhub/services/hive_service_factory.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class AnimePicsProvider with ChangeNotifier {
  final List<AniPic> _anipics = [];
  final List<String> _tags = [];
  final List<Rating> _rating = [Rating.safe];
  final List<AniPic> _favorites = [];
  bool _isLoading = false;
  bool _isErrored = false;
  int _pageSize = 8;
  String _errorMessage = "";

  bool get isLoading => _isLoading;
  bool get isErrored => _isErrored;
  int get pageSize => _pageSize;
  String get errorMessage => _errorMessage;
  List<AniPic> get anipics => List.unmodifiable(_anipics);
  List<String> get tags => List.unmodifiable(_tags);
  List<Rating> get rating => List.unmodifiable(_rating);
  List<AniPic> get favorites => List.unmodifiable(_favorites);

  void loadFavorites() async {
    notifyListeners();
    try {
      final Box<AniPic> favs =
          await HiveServiceFactory.getBox<AniPic>("favorites");
      _favorites.clear();
      _favorites.addAll(favs.values);
      _isErrored = false;
    } catch (e) {
      debugPrint("Error loading favorites: $e");
      _isErrored = true;
      _errorMessage = "Error loading favorites";
    } finally {
      notifyListeners();
    }
  }

  Future<void> addFavorite(AniPic aniPic) async {
    try {
      final Box<AniPic> favs =
          await HiveServiceFactory.getBox<AniPic>("favorites");
      await favs.put(aniPic.id, aniPic);
      _favorites.add(aniPic);
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding favorite: $e");
    }
  }

  Future<void> removeFavorite(AniPic aniPic) async {
    try {
      final Box<AniPic> favs =
          await HiveServiceFactory.getBox<AniPic>("favorites");
      await favs.delete(aniPic.id);
      _favorites.removeWhere((fav) => fav.id == aniPic.id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error removing favorite: $e");
    }
  }

  Future<void> toggleFavorite(AniPic aniPic) async {
    final isFavorite = _favorites.any((fav) => fav.id == aniPic.id);

    if (isFavorite) {
      await removeFavorite(aniPic);
    } else {
      await addFavorite(aniPic);
    }
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void addTag(String tag) {
    _tags.add(tag);
    notifyListeners();
    debugPrint("tags: $_tags");
  }

  void removeTag(String tag) {
    _tags.remove(tag);
    notifyListeners();
    debugPrint("tags: $_tags");
  }

  void clearAniPics() {
    _anipics.clear();
    _isLoading = false;
    _isErrored = false;
    notifyListeners();
  }

  void addRating(Rating rating) {
    _rating.add(rating);
    notifyListeners();
    debugPrint("rating: $_rating");
  }

  void removeRating(Rating rating) {
    _rating.remove(rating);
    notifyListeners();
    debugPrint("rating: $_rating");
  }

  void clearRating() {
    _rating.clear();
    _rating.add(Rating.safe);
    notifyListeners();
  }

  void clearTags() {
    _tags.clear();
    notifyListeners();
  }

  // setters
  set pageSize(int value) {
    if (value > 0) {
      _pageSize = value;
      notifyListeners();
    }
  }

  Future<void> loadMoreAniPics() async {
    if (isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("loading more ani pics");
      debugPrint("Here");
      final List<AniPic> newAniPics = await Anipicservice()
          .fetchAniPics(
            limit: 10,
            rating: _rating.toList(),
            tags: _tags.toList(),
          );
      _anipics.addAll(newAniPics);
      _isErrored = false;
      _errorMessage = "";
    } catch (e) {
      _isErrored = true;
      _errorMessage = "Error loading ani pics";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  AniPic getAniPicById(int id) {
    return _anipics.firstWhere((aniPic) => aniPic.id == id);
  }

  AniPic getFavoriteById(int id) {
    return _favorites.firstWhere((aniPic) => aniPic.id == id);
  }
}
