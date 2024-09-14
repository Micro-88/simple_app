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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/card_background1.png'), // Add the image path here
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white, // Adjust text color for visibility
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Colors.black,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
