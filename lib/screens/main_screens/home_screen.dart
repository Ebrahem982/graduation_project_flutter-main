import 'package:flutter/material.dart';
import 'package:graduation_project/screens/widgets/app_bar.dart';
import 'package:graduation_project/screens/widgets/book_category.dart';
import 'package:graduation_project/screens/widgets/books_list.dart';
import 'package:graduation_project/services/apis/books_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarWidget(
          isHomeScreen: true,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //*START Search Section
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: TextField(
              //     decoration: InputDecoration(
              //       hintText: "Search for a book, author, or genre",
              //       prefixIcon: const Icon(Icons.search),
              //       contentPadding: const EdgeInsets.symmetric(vertical: 10),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       filled: true,
              //       // fillColor: Colors.grey[100],
              //     ),
              //   ),
              // ),
              //* END Search Section
              //*START Categories Section
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text("Categories", style: TextStyle(fontSize: 16)),
              //       TextButton(onPressed: () {}, child: const Text("See all"))
              //     ],
              //   ),
              // ),
              // const CategoriesList(),
              //*End  Categories Section
              // *Books Category
              const SizedBox(
                height: 20,
              ),
              const BooksCategory(
                title: "Books For Deal",
                isSwap: true,
              ),
              BooksList(
                books: BooksServiceApi().getBooksForSwap(),
                isSwapBook: true,
              ),
              // *END Books Category
              // *Books Category
              const BooksCategory(
                title: "Books for sale",
                isSwap: false,
              ),
              BooksList(
                books: BooksServiceApi().getBooks(),
                isSwapBook: false,
              ),
              // *END Books Category
            ],
          ),
        ),
      ),
    );
  }
}
