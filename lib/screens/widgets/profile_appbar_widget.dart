import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';
import 'package:graduation_project/services/cubits/auth/auth_state.dart';

class ProfileAppBarWidget extends StatelessWidget {
  const ProfileAppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    BlocProvider.of<AuthCubit>(context)
                        .userData!
                        .data!
                        .profilePicture!,
                    width: 40,
                  ),
                ),
              ),
            ),
          );
        } else {
          return IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            icon: const Icon(Icons.login),
          );
        }
      },
    );
  }
}
