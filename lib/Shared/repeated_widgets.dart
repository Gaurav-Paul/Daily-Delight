import "package:flutter/material.dart";

class RepeatedWidgets {
  Widget squareTile(String imagePath, void Function()? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 75.0,
          decoration: BoxDecoration(
              color: Colors.green.shade100,
              border: Border.all(width: 2.5, color: Colors.green.shade200),
              borderRadius: BorderRadius.circular(40.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(imagePath, height: 40),
                Text(
                  "   Sign In With Google",
                  style: TextStyle(color: Colors.green.shade800, fontSize: 18.0),
                )
              ],
            ),
          )),
    );
  }
}
