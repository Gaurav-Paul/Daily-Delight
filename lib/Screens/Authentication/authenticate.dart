import "package:flutter/material.dart";
import "package:internet_connection_checker_plus/internet_connection_checker_plus.dart";
import "package:project_trial/Screens/Authentication/sign_in_or_register_screen.dart";
import "package:project_trial/Screens/network_not_connected_screen.dart";
import "package:provider/provider.dart";

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  //Sign in and Register Page switching

  @override
  Widget build(BuildContext context) {
    InternetStatus currentNetStatus = Provider.of<InternetStatus>(context);
    if (currentNetStatus == InternetStatus.connected) {
      return const SignInOrRegisterScreen();
    } else {
      return const NetworkNotConnect();
    }
  }
}
