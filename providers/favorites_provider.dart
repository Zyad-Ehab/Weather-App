import 'package:flutter/material.dart';
import '../models/favorite_city.dart';
import '../services/storage_service.dart';

class FavoritesProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<FavoriteCity> _favorites = [];

  List<FavoriteCity> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites = await _storageService.getFavorites();
    notifyListeners();
  }

  Future<void> addFavorite(FavoriteCity city) async {
    await _storageService.saveFavorite(city);
    await loadFavorites();
  }

  Future<void> removeFavorite(String cityId) async {
    await _storageService.removeFavorite(cityId);
    await loadFavorites();
  }

  bool isFavorite(String cityId) {
    return _favorites.any((fav) => fav.id == cityId);
  }
}