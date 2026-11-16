import 'package:flutter/material.dart';
import 'package:recetario/models/recipe.dart';
import 'package:recetario/screens/recipe_list_screen.dart';

class FavoritesScreen extends StatelessWidget {
  	const FavoritesScreen({super.key, required this.favorites, required this.onFavoritePressed, required this.onClearFavorites});

	final Set<Recipe> favorites;
	final Function(Recipe recipe) onFavoritePressed;
	final Function() onClearFavorites;

   	@override
	Widget build(BuildContext context) {
		return Scaffold(
		appBar: AppBar(
			title: Text("Receptes Favorites"),
			actions: [
				if (favorites.isNotEmpty)
					IconButton(
						icon: Icon(Icons.delete),
						onPressed: onClearFavorites, 
					),
			],
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