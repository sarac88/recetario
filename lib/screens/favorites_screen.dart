import 'package:flutter/material.dart';
import 'package:recetario/models/recipe.dart';
import 'package:recetario/screens/recipe_list_screen.dart';

class FavoritesScreen extends StatelessWidget {
  	const FavoritesScreen({super.key, required this.favorites, required this.onFavoritePressed});

	final Set<Recipe> favorites;
	final Function(Recipe recipe) onFavoritePressed;

   	@override
	Widget build(BuildContext context) {
		return Scaffold(
		appBar: AppBar(
			title: Text("Receptes Favorites"),
			
		),
		body: favorites.isEmpty
			? Center(child: Text("No tens cap favorit"))
			: RecipeGrid(
				filteredRecipes: favorites.toList(),
				favorites: favorites,
				onFavoritePressed: onFavoritePressed,
				),
		);
	}
}