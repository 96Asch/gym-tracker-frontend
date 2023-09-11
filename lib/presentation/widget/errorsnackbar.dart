import 'package:flutter/material.dart';

SnackBar getErrorSnackbar(Color color, String message) {
  return SnackBar(
    backgroundColor: Color.fromARGB(32, 0, 0, 0),
    shape: RoundedRectangleBorder(
        side: BorderSide.none, borderRadius: BorderRadius.circular(20)),
    duration: Duration(seconds: 3),
    content: Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.error,
              size: 30,
              color: color,
            ),
          ),
          Expanded(
            child: Text(
              message,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.justify,
              softWrap: true,
              style: TextStyle(color: color),
            ),
          )
        ],
      ),
    ),
  );
}
