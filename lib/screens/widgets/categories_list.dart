import 'package:flutter/material.dart';
import 'package:graduation_project/models/category_model.dart';
import 'package:graduation_project/services/apis/category_service.dart';
import 'package:shimmer/shimmer.dart';
import 'category_item.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      height: 105,
      child: FutureBuilder<List<CategoryModel>>(
        future: CategoryService().getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerEffect(context);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return _buildCategoryList(snapshot.data!);
          } else {
            return _buildNoDataWidget();
          }
        },
      ),
    );
  }

  Widget _buildShimmerEffect(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surfaceVariant,
          child: CategoryItem(
            category: CategoryModel(id: 0, name: 'Loading...'),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text('Error: $error'),
    );
  }

  Widget _buildCategoryList(List<CategoryModel> categories) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryItem(
          category: categories[index],
        );
      },
    );
  }

  Widget _buildNoDataWidget() {
    return const Center(
      child: Text('No data available'),
    );
  }
}
