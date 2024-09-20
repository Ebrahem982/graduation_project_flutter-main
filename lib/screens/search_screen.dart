import 'package:flutter/material.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:graduation_project/screens/widgets/single_book_widget.dart';
import 'package:graduation_project/services/apis/books_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                onSubmitted: (value) {
                  setState(() {
                    future = BooksServiceApi().searchBooks(query: value.trim());
                  });
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search for a book...",
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // filled: true,
                  // fillColor: Colors.grey[100],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<BookModel>>(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error'),
                      );
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No books found'),
                        );
                      }
                      return SignleBookWidget(books: snapshot.data!);
                    }
                    return const Center(
                      child: Text('Search for a book...'),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
