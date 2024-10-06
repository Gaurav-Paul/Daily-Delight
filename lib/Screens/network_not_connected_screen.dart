import "package:flutter/material.dart";

class NetworkNotConnect extends StatelessWidget {
  const NetworkNotConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_sharp,
            size: 100,
            color: Colors.red,
          ),
          Text(
            "No Internet",
            style: TextStyle(color: Colors.green[800], fontSize: 20),
          )
        ],
      )),
    );
  }
}
