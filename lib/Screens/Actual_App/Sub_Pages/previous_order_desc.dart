import "package:flutter/material.dart";
import "package:project_trial/Services/auth_class.dart";
import "package:project_trial/Services/database.dart";

class PreviousOrderDesc extends StatefulWidget {
  final int orderNo;
  final int totalOrderCost;
  final Map orderData;
  const PreviousOrderDesc(
      {super.key,
      required this.orderNo,
      required this.totalOrderCost,
      required this.orderData});

  @override
  State<PreviousOrderDesc> createState() => _PreviousOrderDescState();
}

class _PreviousOrderDescState extends State<PreviousOrderDesc> {
  final AuthService _auth = AuthService();

  late final Database _db;
  late final Map orderData = widget.orderData;

  @override
  initState() {
    super.initState();
    _db = Database(uid: _auth.getCurrentUserUID());
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[50],
          title: Text(
            "Order Date: ${orderData["Date"]}",
            style: TextStyle(color: Colors.green[700]),
          ),
        ),
        backgroundColor: Colors.green[50],
        body: ListView.builder(
            itemCount: List.from(orderData.keys).length,
            itemBuilder: (context, index) {
              List allItemsInGivenOrder = List.from(orderData.keys);
              allItemsInGivenOrder.remove("Date");
      
              return index != List.from(orderData.keys).length - 1
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.green[100],
                        child: SizedBox(
                          height: 150,
                          child: Row(children: [
                            SizedBox(
                              height: 150,
                              width: 160,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(_db.getAssetPathFromName(
                                    allItemsInGivenOrder[index])!),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    allItemsInGivenOrder[index],
                                    style: TextStyle(
                                        color: Colors.green[800], fontSize: 22),
                                  ),
                                  Text(
                                    "Amount: ${orderData[allItemsInGivenOrder[index]]["Amount"]}",
                                    style: TextStyle(
                                        color: Colors.green[700], fontSize: 18),
                                  ),
                                  Text(
                                    "Cost: ${orderData[allItemsInGivenOrder[index]]["Cost"]}",
                                    style: TextStyle(
                                        color: Colors.green[700], fontSize: 18),
                                  ),
                                  Text(
                                    "${orderData[allItemsInGivenOrder[index]]["Quantity"]} ${orderData[allItemsInGivenOrder[index]]["Quantity type"]}",
                                    style: TextStyle(
                                        color: Colors.green[700], fontSize: 18),
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13.0, vertical: 10),
                      child: Text(
                        "Total Order Cost: ${widget.totalOrderCost}",
                        style: TextStyle(color: Colors.green[800], fontSize: 24),
                      ),
                    );
            }),
      ),
    );
  }
}
