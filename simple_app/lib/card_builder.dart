import 'package:flutter/material.dart';

Widget buildCard(String text, bool isFront) {
  return Card(
    key: ValueKey(isFront),
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Container(
      width: 300,
      height: 200,
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
