import "package:flutter/material.dart";
import "package:loop_page_view/loop_page_view.dart";
import "package:project_trial/Services/auth_class.dart";
import "package:project_trial/Services/database.dart";
import "package:project_trial/Shared/loading.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";

class ItemDescScreen extends StatefulWidget {
  final List itemVal;
  const ItemDescScreen({super.key, required this.itemVal});

  @override
  State<ItemDescScreen> createState() => _ItemDescScreenState();
}

class _ItemDescScreenState extends State<ItemDescScreen> {
  final LoopPageController _loopPageController = LoopPageController();
  // final Database _database = Database();
  int _currentPage = 0;
  Map<String, dynamic>? userData = {};
  late String uid;
  late int amountInCart = 0;
  late final Database _db;
  late final AuthService _auth;
  late bool addToCartButtonLoading;
  var itemData = {};

  asyncInitStuff() async {
    addToCartButtonLoading = true;
    _auth = AuthService();
    uid = _auth.getCurrentUserUID();
    _db = Database(uid: uid);
    await _db.getUserData().then((val) {
      if (userData != val) {
        if(mounted){setState(() {
          userData = val;
          addToCartButtonLoading = false;
        });}
      }
    });
    if (userData!["Cart Items"].toString().contains(widget.itemVal[0])) {
      amountInCart =
          int.parse(userData!["Cart Items"][widget.itemVal[0]]["Amount"]);
    } else {
      amountInCart = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    asyncInitStuff();
  }

  @override
  void dispose() {
    if (amountInCart == 0) {
      _db.removeItemFromCart(widget.itemVal[0]);
    } else {
      _db.addOrUpdateItemToCart(widget.itemVal[0], {
        "Amount": amountInCart.toString(),
        "Quantity": (int.parse(widget.itemVal[3]) * amountInCart).toString(),
        "Quantity type": widget.itemVal[4],
        "Cost": (int.parse(widget.itemVal[2]) * amountInCart).toString()
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return MediaQuery.withNoTextScaling(
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.itemVal[0]),
            backgroundColor: Colors.green[50],
            foregroundColor: Colors.green[800],
          ),
          body: SingleChildScrollView(
              child: Container(
            height: screenHeight - 97,
            color: Colors.green[50],
            child: Column(
              children: [
                // Main Image PageView
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green[100],
                    ),
                    child: SizedBox(
                      width: 500,
                      height: 500.0,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 450,
                            child: LoopPageView.builder(
                              allowImplicitScrolling: true,
                              onPageChanged: (value) {
                                setState(() => _currentPage = value);
                              },
                              controller: _loopPageController,
                              itemCount: widget.itemVal[1].length,
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(widget.itemVal[1][index]));
                              },
                            ),
                          ),
      
                          // Spacing
                          const SizedBox(height: 5),
      
                          //Indicator
                          AnimatedSmoothIndicator(
                            activeIndex: _currentPage,
                            count: widget.itemVal[1].length,
                            effect: SwapEffect(
                                dotColor: Colors.green.shade200,
                                activeDotColor: Colors.green),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
      
                // Items Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(
                        widget.itemVal[0],
                        style:
                            TextStyle(color: Colors.green[700], fontSize: 36.0),
                      ),
                    ],
                  ),
                ),
      
                // Single Item Quantity
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "${widget.itemVal[3]}${widget.itemVal[4]}",
                        style:
                            TextStyle(color: Colors.green[500], fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
      
                // Single Items price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${widget.itemVal[2]}",
                        style:
                            TextStyle(color: Colors.green[700], fontSize: 28.0),
                      ),
      
                      // Add to cart Button (When Item is added to the cart the button transforms into the increase/decrease quantity as well as current quantity button)
                      addToCartButtonLoading == true
                          ? Card(
                              color: Colors.green[100],
                              child: const Padding(
                                  padding: EdgeInsets.all(0),
                                  child: SecondaryLoading()))
                          : amountInCart != 0
                              ? Card(
                                  color: Colors.green[100],
                                  child: Row(
                                    children: [
                                      // Increase Item Button
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.green[700],
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            amountInCart += 1;
                                          });
                                        },
                                      ),
      
                                      // current Item Quantity
                                      Text(amountInCart.toString(),
                                          style: TextStyle(
                                              color: Colors.green[900])),
      
                                      // Item Decrease Button
                                      IconButton(
                                        icon: Icon(Icons.remove,
                                            color: Colors.green[700]),
                                        onPressed: () {
                                          setState(() {
                                            amountInCart -= 1;
                                          });
                                          if (amountInCart == 0) {
                                            ScaffoldMessenger.of(context)
                                                .clearSnackBars();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        Colors.green[100],
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    content: Text(
                                                        "${widget.itemVal[0]} Removed From Cart",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .green[600]))));
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                )
                              : Card(
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.green[100],
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        // itemInCart = true;
                                        amountInCart = 1;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              backgroundColor: Colors.green[100],
                                              duration:
                                                  const Duration(seconds: 1),
                                              content: Text(
                                                  "${widget.itemVal[0]} Added To Cart",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.green[600]))));
                                    },
                                    splashColor: Colors.green[200],
                                    child: Padding(
                                      padding: const EdgeInsets.all(11.0),
                                      child: Text("Add to cart",
                                          style: TextStyle(
                                              color: Colors.green[700],
                                              fontSize: 16.0)),
                                    ),
                                  ),
                                )
                    ],
                  ),
                ),
      
                // Similar Items
              ],
            ),
          ))),
    );
  }
}
