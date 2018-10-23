import 'package:flutter/material.dart';

var newGradient = new LinearGradient(
  begin: FractionalOffset.topCenter,
  end: FractionalOffset.bottomCenter,
  colors: [
    const Color.fromARGB(255, 253, 72, 72),
    const Color.fromARGB(255, 87, 97, 249),
  ],
  stops: [0.0, 1.0],
);
var xradient = new LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  stops: [0.01, 0.5, 0.7, 0.8,0.9],
  colors: [
    Color.fromARGB(255, 253, 72, 72),
    Colors.indigo[800],
    Colors.indigo[700],
    Colors.indigo[600],
    Colors.indigo[400],
  ],
);
var myGradient = new LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomLeft,
  colors: [
    Colors.deepOrange,
    Colors.deepOrange.shade50,
    Colors.deepOrange.shade100,
    Colors.deepOrange.shade50,
    Colors.deepOrange.shade400,
  ],
);
var ppGradient = new LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Colors.white,
    Colors.deepOrange.shade50,
    Colors.deepOrange.shade100,
    Colors.deepOrange.shade50,
    Colors.deepOrange.shade50,
  ],
);
