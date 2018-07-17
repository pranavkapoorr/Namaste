import 'package:flutter/material.dart';

var myGradient = new LinearGradient(
  begin: FractionalOffset.topCenter,
  end: FractionalOffset.bottomCenter,
  colors: [
    const Color.fromARGB(255, 253, 72, 72),
    const Color.fromARGB(255, 87, 97, 249),
  ],
  stops: [0.0, 1.0],
);