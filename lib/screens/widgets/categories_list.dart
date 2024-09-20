import 'package:flutter/material.dart';
import 'package:graduation_project/models/category_model.dart';
import 'package:graduation_project/services/apis/category_service.dart';
import 'package:shimmer/shimmer.dart';

import 'category_item.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      height: 105,
      child: FutureBuilder<List<CategoryModel>>(
        future: CategoryService().getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surface,
                  highlightColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: CategoryItem(
                    category: CategoryModel(id: 0, name: 'Loading...'),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CategoryItem(
                  category: snapshot.data![index],
                );
              },
            );
          } else {
            return const Center(
              child: Text('No data'),
            );
          }
        },
      ),
    );
  }
}
