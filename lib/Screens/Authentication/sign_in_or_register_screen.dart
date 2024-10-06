import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:project_trial/Services/auth_class.dart";
import "package:project_trial/Shared/repeated_widgets.dart";
import "package:project_trial/Shared/loading.dart";
import "package:project_trial/Shared/constants.dart";

class SignInOrRegisterScreen extends StatefulWidget {
  const SignInOrRegisterScreen({super.key});

  @override
  State<SignInOrRegisterScreen> createState() => _SignInOrRegisterScreenState();
}

class _SignInOrRegisterScreenState extends State<SignInOrRegisterScreen> {
  final AuthService _auth = AuthService();
  final RepeatedWidgets _repeatedWidgets = RepeatedWidgets();

  String email = "";
  String password = "";

  bool loading = false;
  String errorMessage = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            body: MediaQuery.withNoTextScaling(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Container(
                    color: Colors.green[50],
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 60.0),
                        children: [
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  //Logo Image
                                  const Image(
                                      height: 252,
                                      width: 312.9,
                                      image: AssetImage(
                                          "assets/Logo/Daily Delight Logo.png")),
              
                                  //Spacing
                                  const SizedBox(height: 50.0),
              
                                  // Username Text Field
                                  TextFormField(
                                      onChanged: (val) {
                                        setState(() {
                                          email = val;
                                        });
                                      },
                                      style:
                                          TextStyle(color: Colors.green.shade600),
                                      decoration: textFormFieldInputDecor
                                          .copyWith(label: const Text("Email")),
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return "Enter a Email Address";
                                        } else if (!(val.contains("@"))) {
                                          return "Invalid Email Address";
                                        }
                                        return null;
                                      }),
              
                                  //Spacing
                                  const SizedBox(
                                    height: 20.0,
                                  ),
              
                                  // Password Text Field
                                  TextFormField(
                                    onChanged: (val) {
                                      setState(() {
                                        password = val;
                                      });
                                    },
                                    obscureText: true,
                                    style:
                                        TextStyle(color: Colors.green.shade600),
                                    decoration: textFormFieldInputDecor.copyWith(
                                        label: const Text("Password")),
                                    validator: (val) => val!.isEmpty
                                        ? "Enter a Password"
                                        : val.length < 6
                                            ? "Password should be more than 5 characters long"
                                            : null,
                                  ),
              
                                  //Spacing
                                  const SizedBox(
                                    height: 15.0,
                                  ),
              
                                  //Error Message Text
                                  MediaQuery.withNoTextScaling(
                                    child: Text(errorMessage,
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 122, 14, 14),
                                            fontSize: 18.0)),
                                  ),
              
                                  //Spacing
                                  const SizedBox(height: 10),
              
                                  // Sign In Button
                                  MediaQuery.withNoTextScaling(
                                    child: GestureDetector(
                                      child: Container(
                                        width: 400.0,
                                        height: 75.0,
                                        decoration: BoxDecoration(
                                            color: Colors.green.shade300,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10.0))),
                                        child: Center(
                                            child: Text(
                                          "Sign In",
                                          style: TextStyle(
                                              fontSize: 28.0,
                                              color: Colors.green.shade800),
                                        )),
                                      ),
                                      onTap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          dynamic result = await _auth
                                              .signInOrRegisterWithEmailAndPassword(
                                                  email, password);
                                          if (result == null) {
                                            setState(() {
                                              errorMessage = "Sign In Failed";
                                              loading = false;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ),
              
                                  // Spacing
                                  const SizedBox(
                                    height: 10.0,
                                  ),
              
                                  const Row(
                                    children: [
                                      Expanded(child: Divider()),
                                      SizedBox(width: 10.0),
                                      Text("Or"),
                                      SizedBox(width: 10.0),
                                      Expanded(child: Divider()),
                                    ],
                                  ),
              
                                  // //Spacing
                                  const SizedBox(height: 60.0),
              
                                  // Google Sign In Button
                                  _repeatedWidgets.squareTile(
                                      "assets/Authentication_Logos/google_logo.png",
                                      () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    User? result = await _auth.signInWithGoogle();
                                    if (result == null) {
                                      setState(() {
                                        errorMessage = "Sign In Failed";
                                        loading = false;
                                      });
                                    }
                                  }),
                                ],
                              )),
                        ])),
              ),
            ),
          );
  }
}
