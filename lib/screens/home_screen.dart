import 'package:flutter/material.dart';
import 'package:recetario/models/recipe.dart';
import 'package:recetario/screens/favorites_screen.dart';
import 'package:recetario/screens/recipe_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
	int selectedIndex = 0;
	final Set<Recipe> favorites = {};

	void toggleFavorite(Recipe recipe) {
		if (favorites.contains(recipe)) {
			favorites.remove(recipe);
			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(
					content: Text('${recipe.title} eliminado de favoritos.'),
					persist: false,
					duration: Duration(seconds: 2),
					action: SnackBarAction(
						label: 'Deshacer',
						onPressed: () {
							favorites.add(recipe);
							setState(() {});
						},
					),
				),
			);
		} else {
			favorites.add(recipe);
		}
		setState(() {});
	}

	Future<void> confirmClearFavorites() async {
		final confirmed = await showDialog<bool>(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text('Confirmar'),
					content: Text('¿Estás seguro de que deseas eliminar todos los favoritos?'),
					actions: <Widget>[
						TextButton(
							child: Text('Cancelar'),
							onPressed: () {
								Navigator.of(context).pop();
							},
						),
						TextButton(
							child: Text('Eliminar'),
							onPressed: () {
								setState(() {
									favorites.clear();
								});
								Navigator.of(context).pop();
							},
						),
					],
				);
			},
		);

		debugPrint('Confirmación de eliminación de favoritos: $confirmed');
	}
	
	@override
	Widget build(BuildContext context) {
		final screens = [
			RecipeListScreen(onFavoritePressed: toggleFavorite, favorites: favorites),
			FavoritesScreen(favorites: favorites, onFavoritePressed: toggleFavorite),
		];
	
		return Scaffold(
			body: IndexedStack(
				index: selectedIndex,
				children: screens,
			),
			bottomNavigationBar: NavigationBar(
						selectedIndex: selectedIndex,
						onDestinationSelected: (index) {
							selectedIndex = index;
							setState(() {});
						},
						destinations: [
						NavigationDestination(
							icon: Icon(Icons.restaurant_menu),
							label: 'Inicio',
						),
						NavigationDestination(
							icon: Icon(Icons.favorite),
							label: 'Favoritos',
						),
					],
				)
		);

	}
}