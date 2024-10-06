import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_trial/Shared/constants.dart';

class Database {
  final String uid;
  Database({required this.uid});
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> get getUserDataStream {
    return _db.collection("User Data").doc(uid).snapshots();
  }

  // Method To Get User Data
  Future<Map<String, dynamic>?> getUserData() async {
    var collection = _db.collection('User Data');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      return data;
    } else {
      return null;
    }
  }

  addOrUpdateItemToCart(String dataKeyName, Map<String, String> data) async {
    var userData = await getUserData();
    userData!["Cart Items"][dataKeyName] = data;
    await _db
        .collection("User Data")
        .doc(uid)
        .set(userData, SetOptions(merge: true));
  }

  removeItemFromCart(String itemName) async {
    var userData = await getUserData();
    userData!["Cart Items"].remove(itemName);
    await _db
        .collection("User Data")
        .doc(uid)
        .set(userData, SetOptions(merge: false));
  }

  String? getAssetPathFromName(itemName) {
    for (int i = 0; i < items.length; i++) {
      for (int j = 0; j < items[i].length; j++) {
        if (items[i][j][0] == itemName) {
          return items[i][j][1][0];
        }
      }
    }
    return null;
  }

  List? getitemsListIndexFromName(itemName) {
    for (int i = 0; i < items.length; i++) {
      for (int j = 0; j < items[i].length; j++) {
        if (items[i][j][0] == itemName) {
          return items[i][j];
        }
      }
    }
    return null;
  }

  Future<List> getDataOfachItemInCart() async {
    List itemsList = [];
    var userData = await getUserData();
    List cartItemKeys = List.from(userData!["Cart Items"].keys);
    for (int i = 0; i < cartItemKeys.length; i++) {
      if (!(itemsList.contains(cartItemKeys[i]))) {
        itemsList.add([
          cartItemKeys[i],
          getAssetPathFromName(cartItemKeys[i]),
          userData["Cart Items"][cartItemKeys[i]]["Amount"],
          userData["Cart Items"][cartItemKeys[i]]["Cost"],
          userData["Cart Items"][cartItemKeys[i]]["Quantity"],
          userData["Cart Items"][cartItemKeys[i]]["Quantity type"]
        ]);
      }
    }
    return itemsList;
  }

  addCartItemsToPreviousOrders() async {
    var userData = await getUserData();
    Map orderItems = userData!["Previous Orders"];
    var numOfUserOrders = List.from(orderItems.keys).length;
    List cartItemKeys = List.from(userData["Cart Items"].keys);

    for (int i = 0; i < cartItemKeys.length; i++) {
      if (orderItems.containsKey("Order ${numOfUserOrders + 1}")) {
        orderItems["Order ${numOfUserOrders + 1}"]!.addAll({
          cartItemKeys[i].toString(): {
            "Amount": userData["Cart Items"][cartItemKeys[i]]["Amount"],
            "Cost": userData["Cart Items"][cartItemKeys[i]]["Cost"],
            "Quantity": userData["Cart Items"][cartItemKeys[i]]["Quantity"],
            "Quantity type": userData["Cart Items"][cartItemKeys[i]]
                ["Quantity type"]
          },
          "Date":
              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"
        });
      } else {
        orderItems["Order ${numOfUserOrders + 1}"] = {
          cartItemKeys[i].toString(): {
            "Amount": userData["Cart Items"][cartItemKeys[i]]["Amount"],
            "Cost": userData["Cart Items"][cartItemKeys[i]]["Cost"],
            "Quantity": userData["Cart Items"][cartItemKeys[i]]["Quantity"],
            "Quantity type": userData["Cart Items"][cartItemKeys[i]]
                ["Quantity type"],
          },
          "Date":
              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"
        };
      }
    }
    userData["Cart Items"] = {};
    userData["Previous Orders"] = orderItems;
    _db.collection("User Data").doc(uid).set(userData);
  }

  Future<int> getNoOfPreviouslyPlacedOrders() async {
    var userData = await getUserData();
    int totalNoOfPreviousOrders =
        List.from(userData!["Previous Orders"].keys).length;
    return totalNoOfPreviousOrders;
  }

  createNewUserBaseData(Map<String, Map<String, String>> cartItems,
      Map<String, Map> previousOrders, String name) {
    _db.collection("User Data").doc(uid).set({
      "Name": name,
      "Cart Items": cartItems,
      "Previous Orders": previousOrders
    });
  }
}
