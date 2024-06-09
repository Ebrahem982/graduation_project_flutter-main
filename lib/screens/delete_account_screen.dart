// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/screens/widgets/primary_button.dart';
import 'package:graduation_project/services/apis/auth_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'This action cannot be undone. All your data will be lost.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF757575),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: PrimaryButton(
              text: 'Delete Account',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Form(
                      key: _formKey,
                      child: AlertDialog(
                        title: const Text('Enter your password to confirm'),
                        content: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final deleted =
                                    await AuthService().deleteAccount(
                                  id: BlocProvider.of<AuthCubit>(context)
                                      .userData!
                                      .data!
                                      .id!,
                                  password: _passwordController.text,
                                  token: BlocProvider.of<AuthCubit>(context)
                                      .userData!
                                      .token!,
                                );
                                if (deleted) {
                                  await BlocProvider.of<AuthCubit>(context)
                                      .logout();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/start',
                                    (route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to delete account'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text('Delete'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
