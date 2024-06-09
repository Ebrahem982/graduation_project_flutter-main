// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:graduation_project/screens/widgets/primary_button.dart';
import 'package:graduation_project/screens/widgets/users_books_list.dart';
import 'package:graduation_project/services/apis/books_service.dart';

import '../services/cubits/auth/auth_cubit.dart';

class UserBooksScreen extends StatelessWidget {
  const UserBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Books'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: PrimaryButton(
                text: 'Add book',
                color: null,
                onPressed: () {
                  Navigator.of(context).pushNamed('/add-book');
                }),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<BookModel>>(
                future: BooksServiceApi().getUserBooks(
                    userId: BlocProvider.of<AuthCubit>(context)
                        .userData!
                        .data!
                        .id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No books found'),
                    );
                  }
                  final books = snapshot.data;
                  return UserBookList(books: books!);
                }),
          ),
        ],
      ),
    );
  }
}
