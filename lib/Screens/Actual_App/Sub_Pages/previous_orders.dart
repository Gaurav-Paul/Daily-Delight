import "package:flutter/material.dart";
import "package:loop_page_view/loop_page_view.dart";
import "package:project_trial/Screens/Actual_App/Sub_Pages/previous_order_desc.dart";
import "package:project_trial/Services/auth_class.dart";
import "package:project_trial/Services/database.dart";
import "package:project_trial/Shared/loading.dart";

class PreviousOrders extends StatefulWidget {
  const PreviousOrders({super.key});

  @override
  State<PreviousOrders> createState() => _PreviousOrdersState();
}

class _PreviousOrdersState extends State<PreviousOrders> {
  final AuthService _auth = AuthService();
  late int noOfOrders = 0;
  late final Database _db;
  bool loading = true;
  late Map previousOrders;
  Map loopPagePages = {};

  asyncInitStuff() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    previousOrders = (await _db.getUserData())!["Previous Orders"];
    noOfOrders = List.from(previousOrders.keys).length;
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
    asyncInitStuff();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: const Text("Your Orders"),
          backgroundColor: Colors.green[50],
        ),
        body: loading
            ? const Loading()
            : noOfOrders == 0
                ? Center(
                    child: Text("You Haven't Placed Any Orders",
                        style: TextStyle(color: Colors.green[800], fontSize: 20)))
                : ListView.builder(
                    itemCount: noOfOrders != 0 ? noOfOrders : 1,
                    itemBuilder: (context, mainIndex) {
                      loopPagePages[mainIndex.toString()] = 0;
                      Map currentOrderData =
                          previousOrders["Order ${mainIndex + 1}"];
      
                      List allItemsInGivenOrder =
                          List.from(currentOrderData.keys);
                      allItemsInGivenOrder.remove("Date");
      
                      int currentOrderTotalCost = 0;
      
                      for (int i = 0; i < allItemsInGivenOrder.length; i++) {
                        currentOrderTotalCost += int.parse(
                            currentOrderData[allItemsInGivenOrder[i]]["Cost"]);
                      }
      
                      String itemsBought = "";
      
                      switch (allItemsInGivenOrder.length) {
                        case 1:
                          itemsBought = "${allItemsInGivenOrder[0]}";
                          break;
                        case 2:
                          itemsBought =
                              "${allItemsInGivenOrder[0]}, ${allItemsInGivenOrder[1]}";
                          break;
                        case 3:
                          itemsBought =
                              "${allItemsInGivenOrder[0]}, ${allItemsInGivenOrder[1]}, ${allItemsInGivenOrder[2]}";
      
                          break;
                        case > 3:
                          itemsBought =
                              "${allItemsInGivenOrder[0]}, ${allItemsInGivenOrder[1]}, ${allItemsInGivenOrder[2]}...";
      
                          break;
                      }
                      String orderDate = currentOrderData["Date"];
                      return Card(
                          clipBehavior: Clip.hardEdge,
                          color: Colors.green[100],
                          child: InkWell(
                            splashColor: const Color.fromARGB(255, 172, 221, 176),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return PreviousOrderDesc(
                                  orderNo: mainIndex + 1,
                                  totalOrderCost: currentOrderTotalCost,
                                  orderData: currentOrderData,
                                );
                              }));
                            },
                            child: SizedBox(
                              height: 150,
                              child: Row(children: [
                                SizedBox(
                                  width: 160,
                                  child: Card(
                                    color: Colors.green[100],
                                    child: SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: LoopPageView.builder(
                                          pageSnapping: true,
                                          allowImplicitScrolling: true,
                                          onPageChanged: (val) {
                                            if (mounted) {
                                              setState(() {
                                              });
                                            }
                                          },
                                          itemBuilder: (context, index) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.asset(
                                                _db.getAssetPathFromName(
                                                    allItemsInGivenOrder[index])!,
                                                height: 130,
                                              ),
                                            );
                                          },
                                          itemCount: allItemsInGivenOrder.length),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(),
                                  clipBehavior: Clip.hardEdge,
                                  width: 265,
                                  child:
                                      Wrap(direction: Axis.vertical, children: [
                                    Text("Order Date: $orderDate",
                                        style: TextStyle(
                                            color: Colors.green.shade800,
                                            fontSize: 22)),
                                    Text("Order Cost: $currentOrderTotalCost",
                                        style: TextStyle(
                                            color: Colors.green.shade700,
                                            fontSize: 18)),
                                    Text("Items: $itemsBought",
                                        style: TextStyle(
                                            color: Colors.green.shade700,
                                            fontSize: 16,
                                            decoration: TextDecoration.underline,
                                            overflow: TextOverflow.ellipsis))
                                  ]),
                                )
                              ]),
                            ),
                          ));
                    }),
      ),
    );
  }
}
