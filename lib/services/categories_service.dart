import 'dart:convert';
import 'package:flutter_application_eb/models/category.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse(
        "https://www.themealdb.com/api/json/v2/9973533/categories.php"));

    final List<Category> categories = [];

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      for (var item in data["categories"]) {
        categories.add(Category(item["strCategoryThumb"], item["strCategory"], item["strCategoryDescription"]));
      }
      return categories;
    } else {
      throw Exception("Fallo la conexion");
    }
  }
}
