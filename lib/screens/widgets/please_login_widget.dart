import 'package:flutter/material.dart';

class PleaseLoginWidget extends StatelessWidget {
  const PleaseLoginWidget({
    super.key,
    required this.message,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Please'),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/login');
            },
            child: const Text('Login'),
          ),
          Text('to $message')
        ],
      ),
    );
  }
}
