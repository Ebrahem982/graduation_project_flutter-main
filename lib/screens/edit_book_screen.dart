// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:graduation_project/screens/widgets/primary_button.dart';
import 'package:graduation_project/services/apis/books_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';

class EditBookScreen extends StatefulWidget {
  const EditBookScreen({super.key});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  // TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final book = (ModalRoute.of(context)!.settings.arguments) as BookModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Book'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: titleController..text = book.title!,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: authorController..text = book.author!,
                  decoration: InputDecoration(
                    labelText: 'Author',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: descriptionController..text = book.description!,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  if (book.availability == 'sale') {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        controller: priceController
                          ..text = book.price!.toString(),
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //       labelText: 'Location',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: PrimaryButton(
                  text: "Update",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await BooksServiceApi().editBook(
                        id: book.id!,
                        title: titleController.text,
                        description: descriptionController.text,
                        author: authorController.text,
                        price: priceController.text,
                        token: BlocProvider.of<AuthCubit>(context)
                            .userData!
                            .token!,
                      );

                      if (response) {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/main', (route) => false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Book updated successfully'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to update book'),
                          ),
                        );
                      }
                    }
                  },
                  color: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: PrimaryButton(
                  text: "Delete",
                  onPressed: () async {
                    final response = await BooksServiceApi().deleteBook(
                      bookId: book.id!,
                      token:
                          BlocProvider.of<AuthCubit>(context).userData!.token!,
                    );
                    if (response) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/main', (route) => false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Book deleted successfully'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to delete book'),
                        ),
                      );
                    }
                  },
                  color: Colors.red[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
