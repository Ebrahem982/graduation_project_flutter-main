import 'package:flutter/material.dart';
import 'package:graduation_project/models/category_model.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
  });
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.80 / 4,
            height: MediaQuery.of(context).size.width * 0.80 / 4,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: Color(int.parse('0xFF${category.color}')),
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              category.name!,
              style: const TextStyle(
                // color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
