import 'package:flutter/material.dart';
import 'package:graduation_project/services/apis/books_service.dart';

class BooksCategory extends StatelessWidget {
  const BooksCategory({
    super.key,
    required this.title,
    required this.isSwap,
  });
  final String title;
  final bool isSwap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: "myfont6",
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/books', arguments: {
              'apiCall': isSwap
                  ? BooksServiceApi().getBooksForSwap()
                  : BooksServiceApi().getBooks(),
            });
          },
          child: const Text("See all"),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}

class BooksService {}
