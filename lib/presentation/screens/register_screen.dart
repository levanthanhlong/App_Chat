import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/color_constants.dart';
import '../../core/constants/text_constants.dart';
import '../bloc/auth/auth_bloc.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: BlocProvider(
          create: (context) => AuthBloc(),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailureState) {
                _showErrorMessageDialog(state.error);
              } else if (state is AuthSuccessState) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => HomeScreen(token: state.token)),
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.center,
                          child: const Text(
                            TextConstants.textCreateUser,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  TextConstants.textFullName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _fullNameController,
                                  decoration: const InputDecoration(
                                    hintText: TextConstants.hintTextFullName,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  TextConstants.textUser,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _usernameController,
                                  decoration: const InputDecoration(
                                    hintText: TextConstants.hintTextUser,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  TextConstants.textPassword,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: TextConstants.hintTextPassword,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  TextConstants.textConfirmPassword,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: TextConstants.textConfirmPassword,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    final fullName =
                                        _fullNameController.text.trim();
                                    final username =
                                        _usernameController.text.trim();
                                    final password =
                                        _passwordController.text.trim();
                                    final confirmPassword =
                                        _confirmPasswordController.text.trim();

                                    BlocProvider.of<AuthBloc>(context).add(
                                      RegisterButtonEvent(
                                        fullName,
                                        username,
                                        password,
                                        confirmPassword,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 40),
                                    backgroundColor: ColorConstants.buttonColor,
                                  ),
                                  child: const Text(
                                    TextConstants.textCreateUser,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state is AuthLoadingState)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showErrorMessageDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(errorMessage, textAlign: TextAlign.center),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              FocusScope.of(context).unfocus();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: ColorConstants.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            child: const Center(
              child: Text(TextConstants.textOk, textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
