import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/screens/widgets/app_bar.dart';
import 'package:graduation_project/screens/widgets/please_login_widget.dart';
import 'package:graduation_project/screens/widgets/users_books_list.dart';
import 'package:graduation_project/services/apis/books_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_state.dart';

import '../../models/book_model.dart';
import '../../services/cubits/auth/auth_cubit.dart';
import '../widgets/primary_button.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarWidget(
          isHomeScreen: false,
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: PrimaryButton(
                      color: null,
                      text: 'Add book',
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
                      return UserBookList(
                        books: snapshot.data!,
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const PleaseLoginWidget(message: "add books");
          }
        },
      ),
    );
  }
}
