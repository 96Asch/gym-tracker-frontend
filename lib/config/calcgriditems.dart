import 'package:flutter/material.dart';

int getNumGridItems(BuildContext context) {
  final shortestSide = MediaQuery.of(context).size.shortestSide;

  if (shortestSide < 300) {
    return 2;
  } else if (shortestSide < 400) {
    return 3;
  } else if (shortestSide < 700) {
    return 3;
  } else if (shortestSide < 800) {
    return 4;
  } else if (shortestSide < 900) {
    return 6;
  }
  return 8;
}
