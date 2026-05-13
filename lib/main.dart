import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gymrat_app/screens/welcome_screen.dart';
import 'package:gymrat_app/screens/home_screen.dart';

void main() async {
  // Než spustím aplikaci, musím zajistit, že všechny widgety jsou připravené k použití
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // Jsem už v aplikaci přihlášená nebo ne?
  final bool uzivatelJePrihlasen = prefs.getBool('prihlasen') ?? false;
  runApp(MyApp(jePrihlasen: uzivatelJePrihlasen));
}

// Tahle klása je hlavní obal celé aplky, kde je theme a podobně.
class MyApp extends StatelessWidget {
  final bool jePrihlasen;
	const MyApp({super.key, required this.jePrihlasen});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymRat',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),),
      home: jePrihlasen ? const HomeScreen() : const WelcomeScreen(),
    );
  }
}
