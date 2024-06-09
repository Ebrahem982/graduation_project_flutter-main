import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation_project/screens/widgets/primary_button.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/icon3.png"),
                fit: BoxFit.fill)),
        width: double.infinity,
        height: double.infinity,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Image(
                    image: AssetImage("assets/images/logo6.png"),
                  ),
                  const Text(
                    "Log in",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: "myfont2",
                        fontWeight: FontWeight.w700),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(7), left: Radius.circular(7)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 10, 10, 10),
                          ),
                          hintText: "Enter Email",
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(7), left: Radius.circular(7)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                          suffix: InkWell(
                            onTap: () {
                              isPasswordVisible = !isPasswordVisible;
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.visibility,
                              color: Color.fromARGB(255, 78, 77, 77),
                            ),
                          ),
                          icon: const Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 10, 10, 10),
                            size: 19,
                          ),
                          hintText: "Enter The Password",
                          border: InputBorder.none),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // const Align(
                  //   alignment: Alignment.centerRight,
                  //   child: Text(
                  //     "Forget your password?",
                  //     style: TextStyle(fontSize: 15),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  PrimaryButton(
                    color: null,
                    text: 'Login',
                    isDisabled: isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        // Perform login
                        bool status =
                            await BlocProvider.of<AuthCubit>(context).login(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        if (status) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/main', (route) => false);
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid email or password'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 15, 15, 15),
                                        width: 1.5)),
                                child: SvgPicture.asset(
                                  "assets/images/face.svg",
                                  height: 55,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 22,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 15, 15, 15),
                                        width: 1.5)),
                                child: SvgPicture.asset(
                                  "assets/images/icons8-google.svg",
                                  height: 50,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Do not have an account ?",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/register");
                        },
                        child: const Text(
                          " Register",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
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
