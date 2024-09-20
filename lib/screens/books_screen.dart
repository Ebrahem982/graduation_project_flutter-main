import 'package:flutter/material.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:graduation_project/screens/widgets/single_book_widget.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booksApiCall = (ModalRoute.of(context)!.settings.arguments)
        as Map<String, Future<List<BookModel>>>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color.fromARGB(255, 231, 200, 200),
            ],
          ),
        ),
        child: FutureBuilder<List<BookModel>>(
            future: booksApiCall['apiCall'],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Books Found'));
                }
                return SignleBookWidget(
                  books: snapshot.data!,
                );
              } else {
                return const Center(child: Text('Error'));
              }
            }),
      ),
    );
  }
}

class BookChips extends StatelessWidget {
  const BookChips({
    super.key,
    required this.text,
    required this.color,
  });
  final Widget text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      height: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: text,
    );
  }
}
