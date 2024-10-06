import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:internet_connection_checker_plus/internet_connection_checker_plus.dart";
import "package:project_trial/Screens/Actual_App/Main_pages/account_page.dart";
import "package:project_trial/Screens/Actual_App/Main_pages/cart_page.dart";
import "package:project_trial/Screens/Actual_App/Main_pages/home_page.dart";
import "package:project_trial/Screens/network_not_connected_screen.dart";
import "package:project_trial/Services/auth_class.dart";
import "package:project_trial/Services/database.dart";
import "package:provider/provider.dart";

class ActualMainPage extends StatefulWidget {
  const ActualMainPage({super.key});

  @override
  State<ActualMainPage> createState() => _ActualMainPageState();
}

class _ActualMainPageState extends State<ActualMainPage> {
  int bottomNavBarIndex = 0;
  final AuthService _auth = AuthService();
  late final Database _db = Database(uid: _auth.getCurrentUserUID());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InternetStatus currentNetStatus = Provider.of<InternetStatus>(context);
    if (currentNetStatus == InternetStatus.connected){
    return StreamProvider<DocumentSnapshot<Map<String, dynamic>>?>.value(
      initialData: null,
      value: _db.getUserDataStream,
      child: MediaQuery.withNoTextScaling(
        child: Scaffold(
          backgroundColor: Colors.green[50],
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.green[50],
              title: Text(bottomNavBarIndex == 0
                  ? "Home"
                  : bottomNavBarIndex == 1
                      ? "Cart"
                      : "Account")),
          floatingActionButton: bottomNavBarIndex == 3
              ? FloatingActionButton(
                  splashColor: Colors.green[200],
                  backgroundColor: Colors.green[100],
                  foregroundColor: Colors.green[700],
                  onPressed: () {},
                  child: const Icon(Icons.edit_sharp))
              : null,
        
          // Show Home Page
          body: bottomNavBarIndex == 0
              ? const HomePage()
        
              // // Show catergories Page
              // : bottomNavBarIndex == 1
              //     ? const CategoriesPage()
        
              // Show current cart
              : bottomNavBarIndex == 1
                  ? const CartPage()
        
                  // Show Account Page
                  : const AccountPage(),
          bottomNavigationBar: BottomNavigationBar(
              elevation: 20.0,
              backgroundColor: Colors.green[50],
              selectedItemColor: Colors.green,
              currentIndex: bottomNavBarIndex,
              onTap: (index) {
                setState(() {
                  bottomNavBarIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: "Home"), // Home
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.category_rounded), label: "Categories"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart_outlined),
                    label: "Cart"), // Cart
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_sharp),
                    label: "Account"), // Account
              ]),
        ),
      ),
    );} else {return const NetworkNotConnect();}
  }
}
