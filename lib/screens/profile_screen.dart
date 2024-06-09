import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';
import 'package:graduation_project/services/cubits/auth/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return AuthProfileWidget(
            name: state.user.data!.name!,
            profileImage: state.user.data!.profilePicture!,
          );
        } else if (state is NotAuthenticated) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
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
                  const Text('to view your profile.')
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class AuthProfileWidget extends StatelessWidget {
  const AuthProfileWidget({
    super.key,
    required this.name,
    required this.profileImage,
  });
  final String name;
  final String profileImage;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/profile_bg.png'),
          fit: BoxFit.cover,
        ),
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
          title: const Text('Profile'),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(profileImage, height: 200, width: 200)),
              const SizedBox(height: 16),
              Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Your Profile'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to the profile screen
                  Navigator.of(context).pushNamed('/edit-profile');
                },
              ),
              const Divider(
                // Add a horizontal line
                color: Colors.black,
                thickness: 1,
              ),
              ListTile(
                leading: const Icon(Icons.book_outlined),
                title: const Text('My Books'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to the Books screen
                  Navigator.of(context).pushNamed('/your-books');
                },
              ),
              const Divider(
                // Add a horizontal line
                color: Colors.black,
                thickness: 1,
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to the Books screen
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              // const Divider(
              //   // Add a horizontal line
              //   color: Colors.black,
              //   thickness: 1,
              // ),
              // ListTile(
              //   leading: const Icon(Icons.person_add_outlined),
              //   title: const Text('Invite Friends'),
              //   trailing: const Icon(Icons.arrow_forward_ios),
              //   onTap: () {
              //     // Navigate to the Books screen
              //     // Navigator.of(context).pushNamed('/');
              //   },
              // ),
              const Divider(
                // Add a horizontal line
                color: Colors.black,
                thickness: 1,
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Log Out'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Logout user
                  context.read<AuthCubit>().logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/start', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
