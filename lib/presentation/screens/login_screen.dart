import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/color_constants.dart';
import '../../core/constants/text_constants.dart';
import '../bloc/auth/auth_bloc.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _BodyLoginScreenState();
}

class _BodyLoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailureState) {
            _showErrorMessageDialog(state.error);
          } else if (state is AuthSuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen(token: state.token)),
            );
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  TextConstants.appName,
                ),
                foregroundColor: Colors.blue,
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 100),
                        const Text(
                          TextConstants.textUser,
                          style: TextStyle(
                            fontSize: 20,
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: TextConstants.hintTextPassword,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 100),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                BlocProvider.of<AuthBloc>(context).add(
                                  LoginButtonEvent(
                                    _usernameController.text,
                                    _passwordController.text,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.buttonColor,
                              ),
                              child: const Text(
                                TextConstants.textLogin,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen()),
                                );
                              },
                              child: const Text(
                                TextConstants.textRegister,
                                style: TextStyle(
                                    color: ColorConstants.textRegisterColor),
                              ),
                            ),
                          ],
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
              ),
            ),
          );
        },
      ),
    );
  }

  // hộp thông báo
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
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
