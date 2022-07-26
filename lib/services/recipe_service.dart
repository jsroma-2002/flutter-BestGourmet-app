import 'dart:convert';
import 'package:flutter_application_eb/models/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeService {
  Future<List<Recipe>> getRecipes(String category) async {
    
    final response = await http.get(Uri.parse(
        "https://www.themealdb.com/api/json/v2/9973533/filter.php?c=" + category));

    final List<Recipe> recipes = [];

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      for (var item in data["meals"]) {
        recipes.add(Recipe(item["strMeal"], item["strMealThumb"]));
      }
      return recipes;
    } else {
      throw Exception("Fallo la conexion");
    }
  }
}
