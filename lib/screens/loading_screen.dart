import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String _name = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  void _startGame() {
    if (_name.trim().isEmpty) {
      _name = 'Jugador';
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(playerName: _name.trim())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2EB082),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'SOKOBAN',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Ingresa tu nombre',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: TextField(
                    onChanged: (value) => _name = value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Tu nombre',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    onSubmitted: (_) => _startGame(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2EB082),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'JUGAR',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
