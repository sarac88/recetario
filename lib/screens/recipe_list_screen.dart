import 'package:flutter/material.dart';
import 'package:recetario/models/category.dart';
import 'package:recetario/models/recipe.dart';
import 'package:recetario/repositories/api_recipe_repository.dart';
import 'package:recetario/screens/recipe_detail_screen.dart';
import 'package:recetario/styles/app_styles.dart';
import 'package:recetario/widgets/app_drawer.dart';
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
	final ApiRecipeRepository recipeRepository = ApiRecipeRepository();

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
			apiRecipes = await recipeRepository.getRecipes(searchQuery: searchQuery, categoryId: selectedCategory?.id ?? '');
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
			return await recipeRepository.getCategories();
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
					IconButton(
						onPressed: showFilters,
						icon: Badge(
							isLabelVisible: selectedCategory != null,
							child: Icon(Icons.filter_list)
							),
					),
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
			drawer: AppDrawer(),
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

  	void showFilters() {
		showModalBottomSheet(
			context: context,
			builder: (BuildContext context) => 
				Padding(
				  padding: const EdgeInsets.all(8.0),
				  child: Column(
					mainAxisSize: .min,
					crossAxisAlignment: .stretch,
					children: [
						AppStyles.mediumSeparator,
						Text('Selecciona una categoría',
							style: AppStyles.sectionTitle,
						),
						FutureBuilder<List<Category>>(
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
							return Wrap(
								children: [
									for (final category in categories)
										Padding(
											padding: .symmetric(horizontal: 8),
											child: ChoiceChip(
												label: Text(category.name),
												selected: selectedCategory == category,
												onSelected: (bool selected) async {
													selectedCategory = selected ? category : null;
													Navigator.pop(context);
													await loadRecipes();
													setState(() {});
												},
											),
										),
								],
							);
							},
						),
				  ],),
				)
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
					onTap: () => openRecipe(context, recipe),
				);
			},
		);
	}
}