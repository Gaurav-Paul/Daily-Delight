import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:flutter/services.dart';
import 'package:project_trial/Services/auth_class.dart';
import 'package:project_trial/firebase_options.dart';
import 'package:project_trial/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
    statusBarIconBrightness: Brightness.dark,
  ));
  // Firebase API Initialization
  bool firebasenotinitialized = true;
  while (firebasenotinitialized) {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      firebasenotinitialized = false;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool darkmodeactive = false;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: darkmodeactive ? ThemeData.dark() : ThemeData.light(),
          home: const Wrapper()),
    );
  }
}
