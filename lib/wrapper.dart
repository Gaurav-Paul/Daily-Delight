import "package:flutter/material.dart";
import "package:internet_connection_checker_plus/internet_connection_checker_plus.dart";
import "package:project_trial/Screens/Authentication/authenticate.dart";
import "package:project_trial/Services/auth_class.dart";
import "package:project_trial/Screens/Actual_App/main_page.dart";
import "package:provider/provider.dart";

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    Stream<InternetStatus> isNetConnectedStream =
        InternetConnection().onStatusChange.asBroadcastStream();
    return user != null
        ? StreamProvider<InternetStatus>.value(
          initialData: InternetStatus.connected,
          value: isNetConnectedStream,
          child: const ActualMainPage())
        : StreamProvider<InternetStatus>.value(
          initialData: InternetStatus.connected,
          value: isNetConnectedStream,
          child: const Authenticate());
  }
}
