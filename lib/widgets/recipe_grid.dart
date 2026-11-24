import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetario/models/recipe.dart';
import 'package:recetario/providers/favorites_provider.dart';
import 'package:recetario/screens/recipe_detail_screen.dart';
import 'package:recetario/widgets/recipe_card.dart';

class RecipeGrid extends StatelessWidget {
  const RecipeGrid({super.key, required this.filteredRecipes});

  final List<Recipe> filteredRecipes;

  void toggleFavorite(BuildContext context, Recipe recipe) {
    final favoritesProvider = context.read<FavoritesProvider>();
    final favorites = favoritesProvider.favorites;

    if (favorites.contains(recipe)) {
      favoritesProvider.remove(recipe);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${recipe.title} eliminado de favoritos.'),
          persist: false,
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () {
              favoritesProvider.add(recipe);
            },
          ),
        ),
      );
    } else {
      favoritesProvider.add(recipe);
    }
  }

  void openRecipe(BuildContext context, Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
      ),
      itemCount:
          filteredRecipes.length, // Replace with your actual recipe data source
      itemBuilder: (context, index) {
        final recipe = filteredRecipes[index]; // Replace with your actual recipe data source
        return RecipeCard(
          recipe: recipe,
          onTap: () => openRecipe(context, recipe),
        );
      },
    );
  }
}
