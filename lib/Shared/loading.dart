import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green[50],
        child: Center(
            child: SpinKitWaveSpinner(
          trackColor: Colors.green.shade200,
          waveColor: Colors.greenAccent,
          color: Colors.green.shade600,
          size: 100.0,
        )));
  }
}

class SecondaryLoading extends StatelessWidget {
  const SecondaryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green[100],
        child: Center(
            child: SpinKitRing(
          size: 40.0,
          color: Colors.green.shade600,
        )));
  }
}
