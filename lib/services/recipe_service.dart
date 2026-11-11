import 'package:http/http.dart' as http;
import 'package:recetario/models/category.dart';
import 'package:recetario/models/category_list.dart';
import 'package:recetario/models/recipe.dart';
import 'package:recetario/models/recipe_detail.dart';
import 'package:recetario/models/recipe_list.dart';

class RecipeService {
	final baseUrl = 'https://xupxup.poquesoft.net';

	Future<String> getBody(String path) async {
    final http.Response response = await http.get(Uri.parse('$baseUrl/$path'));
    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}');
    }
    return response.body;
  }

	Future<List<Recipe>> getRecipes({String searchQuery = '', String categoryId = ''}) async {
		final body = await getBody('recipes?search=$searchQuery&category=$categoryId');
		return recipeListFromJson(body).recipes;
	}

	Future<List<Category>> getCategories() async {
		final body = await getBody('categories');
		return categoryListFromJson(body).categories;
	}

	Future<RecipeDetail> getRecipe(int recipeId) async {
		final body = await getBody('recipes/$recipeId');
		return recipeDetailFromJson(body);
	}
}