import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:project_trial/Services/auth_class.dart";
import "package:project_trial/Services/database.dart";
import "package:project_trial/Shared/constants.dart";
import "package:project_trial/Shared/loading.dart";
import "package:provider/provider.dart";

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final Database _db;
  final AuthService _auth = AuthService();
  bool loading = true;
  late dynamic cartData;
  late List cartItems = [];
  int totalCost = 0;

  asyncItemBuilderStuff() async {
    cartData = (await _db.getUserData())!["Cart Items"];
    cartItems = List.from(cartData.keys);
  }

  asyncInitStateStuff() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    cartData = (await _db.getUserData())!["Cart Items"];
    cartItems = List.from(cartData.keys);
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _db = Database(uid: _auth.getCurrentUserUID());
    asyncInitStateStuff();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      setState(() {
        cartData =
            Provider.of<DocumentSnapshot<Map<String, dynamic>>?>(context);
      });
    }
    if (cartData != null) {
      cartData = (cartData.data())["Cart Items"];
      cartItems = List.from(cartData.keys);
      totalCost = 0;
      for (int i = 0; i < cartItems.length; i++) {
        totalCost += int.parse(cartData[cartItems[i]]["Cost"]);
      }
    }
    return loading && cartData != null
        ? const Loading()
        : cartItems.isNotEmpty
            ? MediaQuery.withNoTextScaling(
              child: StatefulBuilder(
                  builder: (context, setState) => ListView.builder(
                      itemCount: cartItems.length + 1,
                      itemBuilder: (context, index) {
                        asyncItemBuilderStuff();
                        if (index <= cartItems.length - 1) {
                          var currentItemName = cartItems[index];
                          String currentItemAmount =
                              cartData![currentItemName]["Amount"];
                          String currentItemCost =
                              cartData[currentItemName]["Cost"];
                          String currentItemQuantity =
                              cartData[currentItemName]["Quantity"];
                          String currentItemQuantityType =
                              cartData[currentItemName]["Quantity type"];
              
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              color: Colors.green[100],
                              child: InkWell(
                                onTap: () {
                                  displayItemDescScreen(
                                      context,
                                      _db.getitemsListIndexFromName(
                                          currentItemName)!);
                                },
                                splashColor:
                                    const Color.fromARGB(255, 172, 221, 176),
                                child: SizedBox(
                                  height: 150,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 150,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset(
                                            _db.getAssetPathFromName(
                                                currentItemName)!,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Wrap(
                                        direction: Axis.vertical,
                                        children: [
                                          Text(
                                            "$currentItemName",
                                            style: TextStyle(
                                                color: Colors.green[800],
                                                fontSize: 22),
                                          ),
                                          Text(currentItemAmount,
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontSize: 18)),
                                          Text(
                                              "$currentItemQuantity $currentItemQuantityType",
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontSize: 18)),
                                          Text("Cost: $currentItemCost",
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontSize: 18))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Total Cart Cost: $totalCost",
                                  style: TextStyle(
                                      color: Colors.green[800],
                                      fontSize: 24,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.green[800]),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[100],
                                        foregroundColor: Colors.green[700]),
                                    onPressed: () {
                                      _db.addCartItemsToPreviousOrders();
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              backgroundColor: Colors.green[100],
                                              duration:
                                                  const Duration(seconds: 1),
                                              content: Text(
                                                  "Successfully Bought All ${cartItems.length} items",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.green[600]))));
                                    },
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Buy Now"),
                                      ],
                                    ))
                              ],
                            ),
                          );
                        }
                      }),
                ),
            )
            : Center(
                child: Text(
                "No Items in Cart",
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 28,
                ),
              ));
  }
}
