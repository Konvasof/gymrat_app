import 'package:flutter/material.dart';
import 'dart:async'; // Pro práci s časem

// Stateful obsahuje časovou složku
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _pruhlednostTextu = 0.0;

  @override
  void initState() {
    super.initState();  
    // po půl vteříně spustíme funkci, která změní průhlednost textu
    Future.delayed(const Duration(milliseconds: 3500), () {
      // Měníme stav, aby se text objevil
      setState(() {
        _pruhlednostTextu = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_screen_tiger.webp',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6), // 60% tmavost
            ),
          ),
          SafeArea( // Ochrání text před výřezem kamery iPhonu
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  AnimatedOpacity(
                    opacity: _pruhlednostTextu, 
                    duration: const Duration(seconds: 2), 
                    child: const Text(
                      'Vítej v GymRat!',
                      style: TextStyle(
                        fontSize: 50, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white, 
                        shadows: [
                          Shadow(
                            blurRadius: 10.0, // První, jemnější vrstva záře
                            color: Colors.greenAccent, // Svítivě zelená barva
                            offset: Offset(0, 0), // Žádný posun, svítí to přímo zpod textu
                          ),
                          Shadow(
                            blurRadius: 30.0, // Druhá, masivní vrstva záře
                            color: Colors.greenAccent,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  
                  // Vyladěné zelené tlačítko
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.green.shade600, 
                      foregroundColor: Colors.white, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), 
                      ),
                    ),
                    onPressed: () {
                      print('Tlačítko stisknuto');
                    },
                    child: const Text(
                      'Vytvořit účet', 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ), 
        ],
      ),
    );
  }
}