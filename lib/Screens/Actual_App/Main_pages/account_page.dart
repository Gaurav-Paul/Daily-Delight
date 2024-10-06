import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:project_trial/Screens/Actual_App/Sub_Pages/previous_orders.dart";
import "package:project_trial/Services/auth_class.dart";
import "package:project_trial/Shared/loading.dart";

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 2.5),
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 2.5),
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 2.5),
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 2.5),
    ]).animate(_animationController);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 2.5),
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 2.5),
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 2.5),
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 2.5),
    ]).animate(_animationController);

    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : MediaQuery.withNoTextScaling(
          child: SingleChildScrollView(
              child: Container(
                height: 888,
                width: 500,
                color: Colors.green[50],
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (BuildContext context, Widget? child) {
                            return Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(200)),
                                  gradient: LinearGradient(
                                      begin: _topAlignmentAnimation.value,
                                      end: _bottomAlignmentAnimation.value,
                                      colors: [
                                        Colors.green.withOpacity(.8),
                                        Colors.green.withAlpha(90)
                                      ])),
                              height: 250,
                              width: 250,
                              child: Icon(Icons.account_circle,
                                  size: 250,
                                  color: Colors.black.withOpacity(.65)),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Card(
                          color: Colors.green[200],
                          child: Column(
                            children: [
                              Card(
                                color: Colors.green[100],
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                        child: Text("Name: Username",
                                            style: TextStyle(
                                                fontSize: 32.0,
                                                color: Colors.green[800])))),
                              ),
          
                              // Orders List Tile
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  splashColor: Colors.green[50],
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return const PreviousOrders();
                                    }));
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  tileColor: Colors.green[100],
                                  // contentPadding: const EdgeInsets.all(16.0),
                                  leading: const Text("Orders"),
                                  trailing: const Icon(Icons.chevron_right_sharp),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[100],
                              foregroundColor: Colors.green[700]),
                          onPressed: () {
                            try {
                              loading = true;
                              _auth.signOut();
                            } catch (e) {
                              loading = false;
                              if (kDebugMode) {
                                print(e.toString());
                              }
                            }
                          },
                          icon: const Icon(Icons.logout_sharp),
                          label: const Text("Logout"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        );
  }
}
