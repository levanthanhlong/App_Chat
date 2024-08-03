

import 'package:app_chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:app_chat/presentation/bloc/friend/friend_bloc.dart';
import 'package:app_chat/presentation/bloc/user/user_bloc.dart';
import 'package:app_chat/presentation/screens/home_screen.dart';
import 'package:app_chat/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/text_constants.dart';
import 'core/di/di.dart';


void main() {
  configureInjection();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(),
        ),
        BlocProvider<FriendBloc>(
          create: (_) => FriendBloc(),
        ),
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    ),
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(CheckUser());

    return Scaffold(
      body: Center(
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserAuthenticatedState) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (_) => HomeScreen(token: state.token)),
              );
            } else if (state is UserUnauthenticatedState) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(
                size: 100,
              ),
              Text(
                TextConstants.appName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
