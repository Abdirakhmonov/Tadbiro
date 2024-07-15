import 'package:examen_4/cubits/auth_cubit.dart';
import 'package:examen_4/views/screens/home_screen.dart';
import 'package:examen_4/views/screens/registration_screen.dart';
import 'package:examen_4/views/screens/settings_screen.dart';
import 'package:examen_4/views/widgets/check_auth.dart';
import 'package:examen_4/views/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyReset = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final resetPasswordController = TextEditingController();
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
          title: const Text("Ro'yhatdan otmagan!"),
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

  void showResetPasswordDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Enter email",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            content: Form(
              key: _formKeyReset,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: resetPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text("Cancel")),
              FilledButton(onPressed: (){
                if(_formKeyReset.currentState!.validate()){
                  final email = resetPasswordController.text;
                  context.read<AuthCubit>().resetPasswordUser(email);
                  Navigator.pop(context);
                }

              }, child: const Text("Send"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login here",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF1F41BB)),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome back you've been missed!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                MyTextField(
                  hintText: "Email",
                  controller: emailController,
                  validator: (value) {
                    return checkAuth.validateEmail(value);
                  },
                ),
                const SizedBox(height: 20),
                MyTextField(
                    hintText: "Password",
                    controller: passwordController,
                    validator: (value) {
                      return checkAuth.validatePassword(value);
                    }),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed:
                      showResetPasswordDialog,
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff1F41BB)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final email = emailController.text;
                      final password = passwordController.text;
                      context.read<AuthCubit>().loginUser(email, password);
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
                        "Sign in",
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
                            builder: (context) => const RegistrationScreen()));
                  },
                  child: const Text(
                    "Create new account",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}