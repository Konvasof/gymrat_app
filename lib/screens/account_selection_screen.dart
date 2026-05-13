import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gymrat_app/screens/home_screen.dart';
import 'dart:math' as math;

class AccountSelectionScreen extends StatefulWidget {
  const AccountSelectionScreen({super.key});

  @override
  State<AccountSelectionScreen> createState() => _AccountSelectionScreenState();
}

class _AccountSelectionScreenState extends State<AccountSelectionScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  
  String _mirroredName = '';
  
  late AnimationController _typewriterController;
  late Animation<int> _characterCount;
  final String _fullTitle = 'RESPEKT SE NEKUPUJE, RESPEKT SE ZVEDÁ.';

  late AnimationController _matrixController;

  @override
  void initState() {
    super.initState();
    
    // --- 1. Hardcore Typewriter Logika ---
    _typewriterController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _fullTitle.length * 120), // Zpomalené psaní
    );

    _characterCount = StepTween(begin: 0, end: _fullTitle.length).animate(
      CurvedAnimation(parent: _typewriterController, curve: Curves.linear),
    );

    // --- 2. Dynamická slova na pozadí (Zatím vypnutá) ---
    _matrixController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Rychlost průběhu
    ); // POZOR: Smazali jsme ..repeat()! Už to nezačíná samo.

    // --- POSLUCHAČ: Čekáme, až se dopíše text ---
    _typewriterController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Jakmile je psací stroj hotový, spustíme padající slova
        _matrixController.repeat();
      }
    });

    // Spustíme psaní textu
    _typewriterController.forward();

    // Mirroring textu
    _controller.addListener(_updateMirroredText);
  }

  void _updateMirroredText() {
    setState(() {
      _mirroredName = _controller.text;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updateMirroredText);
    _controller.dispose();
    _typewriterController.dispose();
    _matrixController.dispose();
    super.dispose();
  }

  Future<void> _saveAndGoHome(String name) async {
    final cisteJmeno = name.trim();
    if (cisteJmeno.isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('prihlasen', true);
    await prefs.setString('jmeno_uzivatele', cisteJmeno);

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // --- VRSTVA 1: ORANŽOVÁ PADAJÍCÍ SLOVA ---
          AnimatedBuilder(
            animation: _matrixController,
            builder: (context, child) {
              return CustomPaint(
                painter: MatrixRainPainter(
                  progress: _matrixController.value,
                ),
                child: Container(),
              );
            },
          ),

          // --- VRSTVA 2: OBSAH OBRAZOVKY ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: Center(
                      child: FittedBox(
                        child: _mirroredName.isEmpty
                            ? Container()
                            : Text(
                                _mirroredName.toUpperCase(),
                                style: GoogleFonts.anton(
                                  fontSize: 100,
                                  color: Colors.white,
                                  letterSpacing: 3.0,
                                  shadows: const [
                                    // Změnily jsme i stíny zrcadleného textu na oranžové
                                    Shadow(blurRadius: 10.0, color: Colors.orangeAccent, offset: Offset(0, 0)),
                                    Shadow(blurRadius: 30.0, color: Colors.orange, offset: Offset(0, 0)),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),

                  AnimatedBuilder(
                    animation: _characterCount,
                    builder: (context, child) {
                      String displayedText = _fullTitle.substring(0, _characterCount.value);
                      return SizedBox(
                        height: 80,
                        child: Text(
                          displayedText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.bebasNeue(
                            fontSize: 32, 
                            color: Colors.white,
                            letterSpacing: 1.5,
                            height: 1.2,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  
                  TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    cursorColor: Colors.orangeAccent, // Oranžový kurzor
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.02),
                      hintText: 'Tvoje legendární jméno',
                      hintStyle: const TextStyle(color: Colors.white38),
                      // Oranžové okraje
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orangeAccent.withOpacity(0.5), width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                      side: const BorderSide(color: Colors.orangeAccent, width: 2), // Oranžový okraj tlačítka
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    onPressed: () => _saveAndGoHome(_controller.text),
                    child: Text(
                      'POTVRDIT JMÉNO', 
                      style: GoogleFonts.urbanist(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 2.0,
                        shadows: const [Shadow(blurRadius: 10, color: Colors.orangeAccent)] // Oranžový stín nápisu
                      )
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- TADY JE UPRAVENÝ EFEKT PADAJÍCÍCH SLOV ---
class MatrixRainPainter extends CustomPainter {
  final double progress;
  MatrixRainPainter({required this.progress});

  // Snížili jsme počet sloupců na 12, aby to s obřími mezerami nebylo přeplácané
  static final List<_MatrixColumn> _columns = List.generate(12, (index) => _MatrixColumn());

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0.0) return; // Nekreslit, dokud se animace nespustí
    
    if (_columns.first.x == 0) {
      for (var col in _columns) { col.init(size); }
    }

    final paint = Paint()
      ..color = Colors.orangeAccent.withOpacity(0.5) // Změna na oranžovou
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (var col in _columns) {
      // TADY JE TVŮJ NÁSOBIČ: Mezera mezi slovy je 9x větší než samotné písmo
      double spacing = col.fontSize * 9.0; 
      double totalColumnHeight = col.codes.length * spacing;

      // Zrychlený výpočet pádu, protože slova jsou daleko od sebe
      double yPos = (col.startY + (progress * col.speed * 1200)) % (size.height + totalColumnHeight);
      
      for (int i = 0; i < col.codes.length; i++) {
        double charY = yPos - (i * spacing); // Slova jsou teď hrozně daleko od sebe
        
        if (charY < -50 || charY > size.height + 50) continue;

        // První slovo ("hlava") je jasně bílé, zbytek oranžový a mizí do průhledna
        paint.color = i == 0 
            ? Colors.white.withOpacity(0.4) 
            : Colors.orangeAccent.withOpacity((1.0 - (i / col.codes.length)).clamp(0.05, 0.3));

        textPainter.text = TextSpan(
          text: col.codes[i], 
          style: TextStyle(
            color: paint.color, 
            fontSize: col.fontSize, 
            fontWeight: FontWeight.w900, // Tlustší písmo, ať slova vyniknou
            fontFamily: 'monospace'
          )
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(col.x, charY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant MatrixRainPainter oldDelegate) => true;
}

class _MatrixColumn {
  double x = 0;
  double startY = 0;
  double speed = 0;
  double fontSize = 0;
  List<String> codes = [];
  final _random = math.Random();

  void init(Size size) {
    x = _random.nextDouble() * size.width;
    startY = _random.nextDouble() * size.height;
    speed = 0.5 + _random.nextDouble() * 1.5; 
    fontSize = 14 + _random.nextDouble() * 6; // Malinko zmenšeno, ať se slova nepletou
    
    final hardcoreSlova = [
      'PR', 'BENCH', 'DŘEP', 'OSA', 'ČINKY', 
      '150kg', '80kg', '90kg', '100kg', '50kg', 
      '20+20=60', 'KREATIN'
    ];
    
    // Generátor vybere 5 až 10 slov do každého sloupce
    codes = List.generate(
      5 + _random.nextInt(6), 
      (index) => hardcoreSlova[_random.nextInt(hardcoreSlova.length)]
    );
  }
}