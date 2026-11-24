import 'package:flutter/material.dart';
import 'package:recetario/models/recipe.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<Recipe> favorites = {};

  void add(Recipe recipe) {
    favorites.add(recipe);
    notifyListeners();
  }

  void remove(Recipe recipe) {
    favorites.remove(recipe);
    notifyListeners();
  }

  void clearFavorites() {
    favorites.clear();
    notifyListeners();
  }

  bool toggleFavorite(Recipe recipe) {
    if (favorites.contains(recipe)) {
      remove(recipe);
      return false;
    } else {
      add(recipe);
      return true;
    }
  }
}
