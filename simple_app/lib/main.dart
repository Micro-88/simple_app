import 'package:flutter/material.dart';
import 'dart:math'; // Import this for pi

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flip Card Example'),
        ),
        body: FlipCard(),
      ),
    );
  }
}

class FlipCard extends StatefulWidget {
  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool isFront = true;

  void _flipCard() {
    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _flipCard, // Flip the card when tapped
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final rotate = Tween(begin: pi, end: 0.0).animate(animation);
            return AnimatedBuilder(
              animation: rotate,
              child: child,
              builder: (context, child) {
                final isUnder = (ValueKey(isFront) != child?.key);
                final value = isUnder ? min(rotate.value, pi / 2) : rotate.value;
                return Transform(
                  transform: Matrix4.rotationY(value),
                  child: child,
                  alignment: Alignment.center,
                );
              },
            );
          },
          child: isFront
              ? _buildFrontCard() // Front of the card
              : _buildBackCard(), // Back of the card
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Card(
      key: ValueKey(true),
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
            'Elijah',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Card(
      key: ValueKey(false),
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
            'BADING',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
