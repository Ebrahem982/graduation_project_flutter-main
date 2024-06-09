// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/user_model.dart';
import 'package:graduation_project/screens/widgets/primary_button.dart';
import 'package:graduation_project/services/apis/auth_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  File? image;
  String? imageUrl;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
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
            title: const Text('Your Profile'),
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Builder(
                            builder: (context) {
                              if (image != null) {
                                return Image.file(
                                  image!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                );
                              } else if (imageUrl != null) {
                                return Image.network(
                                  imageUrl!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Image.network(
                                  BlocProvider.of<AuthCubit>(context)
                                      .userData!
                                      .data!
                                      .profilePicture!,
                                  height: 200,
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: () async {
                                XFile? pickedImage =
                                    await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 20,
                                );
                                if (pickedImage != null) {
                                  image = File(pickedImage.path);
                                  imageUrl = pickedImage.path;
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController
                        ..text = BlocProvider.of<AuthCubit>(context)
                            .userData!
                            .data!
                            .name!,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneController
                        ..text = BlocProvider.of<AuthCubit>(context)
                            .userData!
                            .data!
                            .phone!,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController
                        ..text = BlocProvider.of<AuthCubit>(context)
                            .userData!
                            .data!
                            .email!,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                        isDisabled: isLoading,
                        text: 'Update profile',
                        onPressed: () async {
                          // Update the user data
                          BlocProvider.of<AuthCubit>(context)
                              .userData!
                              .data!
                              .name = nameController.text;
                          BlocProvider.of<AuthCubit>(context)
                              .userData!
                              .data!
                              .email = emailController.text;
                          BlocProvider.of<AuthCubit>(context)
                              .userData!
                              .data!
                              .phone = phoneController.text;
                          setState(() {
                            isLoading = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            // Update the profile
                            if (image != null) {
                              var refStorage = FirebaseStorage.instance
                                  .ref()
                                  .child('profile_pictures')
                                  .child(
                                      '${DateTime.now().millisecondsSinceEpoch}.jpg');
                              await refStorage.putFile(
                                image!,
                                SettableMetadata(contentType: 'image/jpeg'),
                              );
                              imageUrl = await refStorage.getDownloadURL();
                              BlocProvider.of<AuthCubit>(context)
                                  .userData!
                                  .data!
                                  .profilePicture = imageUrl;
                            }
                            final updated = await AuthService().updateProfile(
                              id: BlocProvider.of<AuthCubit>(context)
                                  .userData!
                                  .data!
                                  .id!,
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              profileImage: imageUrl,
                              token: BlocProvider.of<AuthCubit>(context)
                                  .userData!
                                  .token!,
                            );
                            if (updated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Profile updated successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              UserModel user = prefs.getString('user') != null
                                  ? UserModel.fromJson(
                                      jsonDecode(prefs.getString('user')!),
                                    )
                                  : UserModel();
                              user.data!.name = nameController.text;
                              user.data!.email = emailController.text;
                              user.data!.phone = phoneController.text;
                              user.data!.profilePicture =
                                  imageUrl ?? user.data!.profilePicture;
                              prefs.setString(
                                  'user', jsonEncode(user.toJson()));

                              setState(() {
                                isLoading = false;
                                image = null;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to update profile'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              isLoading = false;
                            }
                          }
                        },
                        color: null)
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
