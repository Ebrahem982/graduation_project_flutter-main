// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/category_model.dart';
import 'package:graduation_project/screens/widgets/primary_button.dart';
import 'package:graduation_project/services/apis/books_service.dart';
import 'package:graduation_project/services/apis/category_service.dart';
import 'package:image_picker/image_picker.dart';

import '../services/cubits/auth/auth_cubit.dart';

class AddBookFormScreen extends StatefulWidget {
  const AddBookFormScreen({super.key});

  @override
  State<AddBookFormScreen> createState() => _AddBookFormScreenState();
}

class _AddBookFormScreenState extends State<AddBookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String? cagegoryId;
  String? selectedStatus;
  String? selectedAvailability;
  File? image;
  String? imageUrl;
  bool isLoading = false;

  var future;

  String? checkValidation(value) {
    if (value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    future = CategoryService().getCategories();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    authorController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Add Book'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      // pick image
                      XFile? xfile = await ImagePicker().pickImage(
                          source: ImageSource.gallery, imageQuality: 50);
                      if (xfile != null) {
                        image = File(xfile.path);

                        setState(() {});
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBA9590),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Builder(
                        builder: (context) {
                          if (image == null) {
                            return const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Add Image',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Image.file(
                              image!,
                              fit: BoxFit.contain,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: titleController,
                    validator: checkValidation,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: authorController,
                    validator: checkValidation,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Author',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                    validator: checkValidation,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Describe what the book is about',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  //* Category dropdown
                  FutureBuilder<List<CategoryModel>>(
                      future: future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if (snapshot.hasData) {
                          final categories = snapshot.data;
                          return DropdownButtonFormField(
                            validator: (value) =>
                                value == null ? 'field required' : null,
                            items:
                                categories!.map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                value: e.id.toString(),
                                child: Row(
                                  children: [
                                    if (e.icon != null) ...[
                                      Image.network(
                                        e.icon!,
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                    Text(e.name!),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              // select category
                              setState(() {
                                cagegoryId = value;
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Category',
                            ),
                          );
                        }
                        return const Center(
                          child: Text('No categories found'),
                        );
                      }),
                  const SizedBox(height: 20),
                  //* Status radio buttons
                  Row(
                    children: [
                      const Text('Condition:'),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'new',
                            groupValue: selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                          ),
                          const Text('New'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'used',
                            groupValue: selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                          ),
                          const Text('Used'),
                        ],
                      ),
                    ],
                  ),
                  //* Availability radio buttons
                  Row(
                    children: [
                      const Text('Availability:'),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'sale',
                            groupValue: selectedAvailability,
                            onChanged: (value) {
                              setState(() {
                                selectedAvailability = value;
                              });
                            },
                          ),
                          const Text('For Sale'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'swap',
                            groupValue: selectedAvailability,
                            onChanged: (value) {
                              setState(() {
                                selectedAvailability = value;
                              });
                            },
                          ),
                          const Text('for Dealing'),
                        ],
                      ),
                    ],
                  ),
                  Builder(
                    builder: (context) {
                      if (selectedAvailability == 'sale') {
                        return TextFormField(
                          controller: priceController,
                          validator: checkValidation,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: "Add book",
                    isDisabled: isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          selectedStatus != null &&
                          selectedAvailability != null &&
                          image != null) {
                        // add book
                        setState(() {
                          isLoading = true;
                        });
                        // upload image to firebase storage
                        var refStorage = FirebaseStorage.instance
                            .ref()
                            .child('books')
                            .child('${DateTime.now().millisecondsSinceEpoch}');
                        await refStorage.putFile(image!,
                            SettableMetadata(contentType: 'image/jpeg'));
                        imageUrl = await refStorage.getDownloadURL();
                        bool addedBook = await BooksServiceApi().addBook(
                          title: titleController.text,
                          author: authorController.text,
                          category: cagegoryId!,
                          status: selectedStatus!,
                          availability: selectedAvailability!,
                          description: descriptionController.text,
                          coverImage: imageUrl!,
                          price: priceController.text,
                          token: BlocProvider.of<AuthCubit>(context)
                              .userData!
                              .token!,
                        );
                        if (addedBook) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Book added successfully'),
                            ),
                          );
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/main', (route) => false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error adding book'),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    color: null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
