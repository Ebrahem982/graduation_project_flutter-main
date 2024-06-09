import 'package:flutter/material.dart';
import 'package:graduation_project/models/category_model.dart';
import 'package:graduation_project/services/apis/books_service.dart';
import 'package:graduation_project/services/apis/category_service.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/categories_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<CategoryModel>>(
          future: CategoryService().getCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/books',
                      arguments: {
                        'apiCall': BooksServiceApi().getBooksByCategory(
                          categoryId: snapshot.data![index].id!,
                        ),
                      },
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.brown[100],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Color(
                            int.parse("0xFF${snapshot.data![index].color}"),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Image.network(snapshot.data![index].icon!),
                          ),
                        ),
                      ),
                      Text(
                        snapshot.data![index].name!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
