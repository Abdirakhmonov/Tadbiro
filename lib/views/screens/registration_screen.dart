import 'package:examen_4/views/screens/home_screen.dart';
import 'package:examen_4/views/screens/login_screen.dart';
import 'package:examen_4/views/screens/settings_screen.dart';
import 'package:examen_4/views/widgets/check_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/auth_cubit.dart';
import '../../cubits/auth_state.dart';
import '../widgets/my_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final checkAuth = CheckAuth();

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().stream.listen((state) {
      if (state is AuthenticatedState) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else if (state is ErrorAuthState) {
        _showErrorDialog(state.message);
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Bunday foydalnuvchi mavjud!"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF1F41BB)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Create an account so you can explore all the existing jobs",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                      hintText: "Username",
                      controller: usernameController,
                      validator: (value) {
                        return checkAuth.validateUsername(value);
                      }),
                  const SizedBox(height: 20),
                  MyTextField(
                      hintText: "Email",
                      controller: emailController,
                      validator: (value) {
                        return checkAuth.validateEmail(value);
                      }),
                  const SizedBox(height: 20),
                  MyTextField(
                      hintText: "Password",
                      controller: passwordController,
                      validator: (value) {
                        return checkAuth.validatePassword(value);
                      }),
                  const SizedBox(height: 30),
                  MyTextField(
                      hintText: "Confirm Password",
                      controller: confirmPasswordController,
                      validator: (value) {
                        return checkAuth.validateConfirmPassword(
                            value, passwordController.text);
                      }),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        final email = emailController.text;
                        final password = passwordController.text;
                        final username = usernameController.text;
                        context
                            .read<AuthCubit>()
                            .registerUser(email, password, username);
                      }
                    },
                    child: Material(
                      elevation: 4, // Add elevation here
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0xff1F41BB)),
                        child: const Center(
                            child: Text(
                          "Sign up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        "Already have an account",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
