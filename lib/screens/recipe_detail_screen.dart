import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetario/models/recipe.dart';
import 'package:recetario/models/recipe_detail.dart';
import 'package:recetario/providers/favorites_provider.dart';
import 'package:recetario/repositories/api_recipe_repository.dart';
import 'package:recetario/repositories/recipe_repository.dart';
import 'package:recetario/styles/app_styles.dart';
import 'package:recetario/widgets/cooking_timer.dart';
import 'package:recetario/widgets/icon_text.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<RecipeDetail> recipeFuture;
  final RecipeRepository recipeRepository = ApiRecipeRepository();

  @override
  void initState() {
    super.initState();
    recipeFuture = loadRecipeDetail();
  }

  Future<RecipeDetail> loadRecipeDetail() async {
    return await recipeRepository.getRecipe(widget.recipe.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recetario'),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<FavoritesProvider>().favorites.contains(
                    widget.recipe,
                  )
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            onPressed: () {
              context.read<FavoritesProvider>().toggleFavorite(widget.recipe);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar la receta'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Receta no encontrada'));
          }
          final recipe = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          widget.recipe.imageUrl,
                          height: 250,
                          width: .infinity,
                          fit: .cover,
                        ),
                        Positioned.fill(
                          child: Container(
                            height: 250,
                            decoration: BoxDecoration(
                              gradient: AppStyles.imageShade.gradient,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          right: 16,
                          child: Text(
                            widget.recipe.title,
                            style: AppStyles.mainTitle,
                          ),
                        ),
                        Positioned(
                          left: 16,
                          top: 16,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppStyles.tagBackgroundColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(widget.recipe.category),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: .symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              IconText(
                                icon: Icons.timer_outlined,
                                text: '30 min',
                              ),
                              IconText(
                                icon: Icons.people_outline,
                                text: '4 personas',
                              ),
                            ],
                          ),
                          AppStyles.mediumSeparator,
                          CookingTimer(minutes: widget.recipe.minutes),
                          SizedBox(height: 16),
                          Text('Ingredientes', style: AppStyles.sectionTitle),
                          AppStyles.smallSeparator,
                          for (final ingredient in recipe.ingredients)
                            Text('• ${ingredient.toString()}'),
                          AppStyles.mediumSeparator,
                          Text('Preparación', style: AppStyles.sectionTitle),
                          AppStyles.smallSeparator,
                          for (var i = 0; i < recipe.steps.length; i++)
                            Text(' ${i + 1}. ${recipe.steps[i]}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
