import 'package:flutter/material.dart';
import 'dart:math'; // For pi
import 'card_builder.dart'; // Import the card builder function
import 'card_data.dart';    // Import the card data

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BackgroundImage(
          child: FlipCardDeck(),
        ),
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  final Widget child;

  BackgroundImage({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image (if you want a global background)
        Image.asset(
          'assets/background.jpg', // Optional global background
          fit: BoxFit.cover,
        ),
        // Child widget
        child,
      ],
    );
  }
}

class FlipCardDeck extends StatefulWidget {
  @override
  _FlipCardDeckState createState() => _FlipCardDeckState();
}

class _FlipCardDeckState extends State<FlipCardDeck> {
  int currentIndex = 0;
  bool isFront = true;

  void _flipCard() {
    setState(() {
      isFront = !isFront;
    });
  }

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % cards.length;
      isFront = true; // Reset to front when switching cards
    });
  }

  void _prevCard() {
    setState(() {
      currentIndex = (currentIndex - 1 + cards.length) % cards.length;
      isFront = true; // Reset to front when switching cards
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _flipCard,
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
                  ? buildCard(
                cards[currentIndex]['frontText']!,
                true,
                frontImage: cards[currentIndex]['front']!,
                backImage: cards[currentIndex]['back']!,
              ) // Front side
                  : buildCard(
                cards[currentIndex]['backText']!,
                false,
                frontImage: cards[currentIndex]['front']!,
                backImage: cards[currentIndex]['back']!,
              ), // Back side
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _prevCard,
                child: Text("Previous"),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _nextCard,
                child: Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
