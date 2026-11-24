import 'package:recetario/models/category.dart';
import 'package:recetario/models/recipe.dart';
import 'package:recetario/models/recipe_detail.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes({String searchQuery = '', String categoryId = ''});
  Future<List<Category>> getCategories();
  Future<RecipeDetail> getRecipe(int recipeId);
}
