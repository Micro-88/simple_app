import 'package:flutter/material.dart';
import 'dart:math'; // For pi
import 'dart:async'; // For Timer
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
  Timer? _timer;
  List<Map<String, String>> shuffledCards = [];

  @override
  void initState() {
    super.initState();
    shuffledCards = List.from(cards); // Copy the original cards list
    _shuffleCards(); // Shuffle the cards
    _startAutoNextCardTimer(); // Start the timer for auto-flipping
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to start the auto next card timer
  void _startAutoNextCardTimer() {
    _timer = Timer.periodic(Duration(seconds: 30), (Timer timer) {
      _nextCard(); // Automatically move to the next card every 30 seconds
    });
  }

  // Function to shuffle the cards
  void _shuffleCards() {
    setState(() {
      shuffledCards.shuffle();
      currentIndex = 0; // Reset currentIndex to 0 after shuffle
      isFront = true; // Reset the card to the front after shuffle
    });
  }

  void _flipCard() {
    setState(() {
      isFront = !isFront;
    });
  }

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % shuffledCards.length;
      isFront = true; // Reset to front when switching cards
    });
  }

  void _prevCard() {
    setState(() {
      currentIndex = (currentIndex - 1 + shuffledCards.length) % shuffledCards.length;
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
                shuffledCards[currentIndex]['frontText']!,
                true,
                frontImage: shuffledCards[currentIndex]['front']!,
                backImage: shuffledCards[currentIndex]['back']!,
              ) // Front side
                  : buildCard(
                shuffledCards[currentIndex]['backText']!,
                false,
                frontImage: shuffledCards[currentIndex]['front']!,
                backImage: shuffledCards[currentIndex]['back']!,
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
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _shuffleCards,
                child: Text("Shuffle"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
