import 'package:dio/dio.dart';
import 'package:graduation_project/models/category_model.dart';
import 'package:graduation_project/services/apis/baseurl.dart';

class CategoryService {
  final dio = Dio();

  Future<List<CategoryModel>> getCategories() async {
    final response = await dio.get('$baseUrl/categories');
    if (response.statusCode == 200) {
      final List<CategoryModel> categories = [];
      for (var category in response.data) {
        categories.add(CategoryModel.fromJson(category));
      }
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
