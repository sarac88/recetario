import 'package:flutter/material.dart';
import 'package:recetario/models/category.dart';
import 'package:recetario/models/recipe.dart';
import 'package:recetario/screens/recipe_detail_screen.dart';
import 'package:recetario/services/recipe_service.dart';
import 'package:recetario/widgets/recipe_card.dart';

class RecipeListScreen extends StatefulWidget {
	const RecipeListScreen({super.key, required this.favorites, required this.onFavoritePressed});
	final Set<Recipe> favorites;
	final Function(Recipe recipe) onFavoritePressed;

  	@override
  	State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
	
	String searchQuery = '';
	TextEditingController searchController = TextEditingController();
	List<Recipe> apiRecipes = [];
	bool isLoading = false;
	Category? selectedCategory;
	late Future<List<Category>> categoriesFuture;
	final recipeService = RecipeService();

	void clearSearch() {
		searchController.clear();
		setState(() {
			searchQuery = '';
		});
	}

	@override
	void initState() {
		super.initState();
		loadRecipes();
		categoriesFuture = loadCategories();
	}


	Future<void> loadRecipes() async {
		setState(() {
			isLoading = true;
		});
		try {
			apiRecipes = await recipeService.getRecipes(searchQuery: searchQuery, categoryId: selectedCategory?.id ?? '');
		} catch (e) {
			if (!mounted) return;
			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(
					content: Text("No se han podido cargar las recetas"),
					action: SnackBarAction(label: "Reintentar", onPressed: loadRecipes),
				),
			);
		}
		setState(() {
			isLoading = false;
		});
	}

	Future<List<Category>> loadCategories() async {
		try {
			return await recipeService.getCategories();
		} catch (e) {
			if (!mounted) return [];
			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(
					content: Text("No se han podido cargar las categorias"),
					action: SnackBarAction(label: "Reintentar", onPressed: loadCategories),
				),
			);
		}
		return [];
	}

	@override
	Widget build(BuildContext context) {
		final List<Recipe> filteredRecipes = apiRecipes.toList();

		return Scaffold(
			appBar: AppBar(
				title: Text('Recetario'),
				actions: [
					// if (selectedIndex == 1 && favorites.isNotEmpty)
					// 	IconButton(
					// 		icon: Icon(Icons.delete),
					// 		onPressed: confirmClearFavorites,
					// 	),
					Padding(
					  padding: .all(8),
					  child: Stack(
					  	alignment: Alignment.center,
					  	children: [
					  		IconButton(
					  			icon: Icon(Icons.favorite),
					  			onPressed: () {
					  				// Navigate to favorites screen
					  			},
					  		),
					  		if (widget.favorites.isNotEmpty)
					  			Positioned(
					  				right: 8,
					  				top: 8,
					  				child: Container(
					  					padding: EdgeInsets.all(1),
					  					decoration: BoxDecoration(
					  						color: Colors.red,
					  						borderRadius: BorderRadius.circular(10),
					  					),
					  					constraints: BoxConstraints(
					  						minWidth: 12,
					  						minHeight: 12,
					  					),
					  					child: Text(
					  						widget.favorites.length.toString(),
					  						style: TextStyle(
					  							color: Colors.white,
					  							fontSize: 10,
					  						),
					  						textAlign: TextAlign.center,
					  					),
					  				),
					  			),
								
					  	],
					  ),
					),
				],
			),
			body: Column(
			  children: [
				Padding(
				  padding: .all(8),
				  child: TextField(
				  	decoration: InputDecoration(
				  		labelText: 'Busca una receta',
				  		border: OutlineInputBorder(),
						prefixIcon: Icon(Icons.search),
						suffixIcon: searchQuery.isNotEmpty
							? IconButton(
								icon: Icon(Icons.clear),
								onPressed: clearSearch,
							)
							: null,
				  	),
					controller: searchController,
				  	onChanged: (value) async {
				  		searchQuery = value;
				  	},
					onSubmitted: (value) async {
						await loadRecipes();
						setState(() {});
					},
				  ),
				),
				SizedBox(
					height: 50,
					child: FutureBuilder<List<Category>>(
						future: categoriesFuture,
						builder: (context, snapshot) {
						if (snapshot.hasError) {
						return Center(child: Text('Error al cargar las categorías'),
						);
						}
						if (!snapshot.hasData) {
						return Center(child: CircularProgressIndicator());
						}
						final categories = snapshot.data!;
						if (categories.isEmpty) {
						return Center(child: Text('No se encontraron categorías'));
						}
						return ListView.builder(
							scrollDirection: .horizontal,
							itemCount: categories.length,
							itemBuilder: (context, index) {
								final category = categories[index];
								return Padding(
								  padding: const EdgeInsets.symmetric(horizontal: 8),
								  child: ChoiceChip(
								  	label: Text(category.name),
								  	selected: selectedCategory == category,
									onSelected: (bool selected) async {
										setState(() {
											selectedCategory = selected ? categories[index] : null;
										});
										await loadRecipes();
										setState(() {});
									}
								  ),
								);
							},
						);
						},
					),
				),
			    Expanded(
			      child: isLoading 
				  	? Center(child: CircularProgressIndicator())
				  	: filteredRecipes.isEmpty
			      	? Center(child: Text('No se encontraron recetas.')) 
					: RecipeGrid(filteredRecipes: filteredRecipes, favorites: widget.favorites, onFavoritePressed: widget.onFavoritePressed),
			    ),
			  ],
			),
		);
	}
}

class RecipeGrid extends StatelessWidget {
	const RecipeGrid({
		super.key,
		required this.filteredRecipes,
		required this.favorites,
		required this.onFavoritePressed,
	});

	final List<Recipe> filteredRecipes;
	final Set<Recipe> favorites;
	final Function(Recipe recipe) onFavoritePressed;

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
			itemCount: filteredRecipes.length, // Replace with your actual recipe data source
			itemBuilder: (context, index) {
				final recipe = filteredRecipes[index]; // Replace with your actual recipe data source
				return RecipeCard(
					recipe: recipe,
					isFavorite: favorites.contains(recipe),
					onFavoritePressed: () => onFavoritePressed(recipe),
				onTap: () {
					openRecipe(context, recipe);
				},// Navigate to recipe detail screen},
							);
				},
			);
	}
}
