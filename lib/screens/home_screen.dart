import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gymrat_app/screens/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Tygr na pozadí
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_screen_tiger.webp',
              fit: BoxFit.cover,
            ),
          ),
          
          // 2. Tmavý filtr pro čitelnost
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          
          // 3. Epesní nápis uprostřed
          Center(
            child: Text(
              'GymRat',
              style: GoogleFonts.bebasNeue(
                fontSize: 100, // Obří text
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2.0, // Mezery mezi písmeny
                shadows: const [
                  Shadow(blurRadius: 15.0, color: Color.fromARGB(255, 0, 0, 0), offset: Offset(0, 0)),
                  Shadow(blurRadius: 40.0, color: Color.fromARGB(255, 207, 86, 5), offset: Offset(0, 0)),
                ],
              ),
            ),
          ),

          // 4. Nenápadné tlačítko pro ODHLÁŠENÍ (vpravo nahoře)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.white70),
                onPressed: () async {
                  // Otevřeme šuplík a smažeme záznam o přihlášení!
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('prihlasen', false);

                  // Přepneme obrazovku zpět na WelcomeScreen
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}