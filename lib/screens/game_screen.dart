import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_state.dart';
import '../widgets/animated_sprite.dart';
import 'video_screen.dart';

class GameScreen extends StatefulWidget {
  final String playerName;
  const GameScreen({Key? key, this.playerName = 'Jugador'}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState _gameState;
  bool _levelCompleted = false;

  @override
  void initState() {
    super.initState();
    _gameState = GameState();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (_levelCompleted) return;

    if (event is KeyDownEvent) {
      int dRow = 0;
      int dCol = 0;

      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        dRow = -1;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        dRow = 1;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        dCol = -1;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        dCol = 1;
      }

      if (dRow != 0 || dCol != 0) {
        setState(() {
          bool moved = _gameState.movePlayer(dRow, dCol);
          if (moved && _gameState.checkWinCondition()) {
            _levelCompleted = true;
            _showWinDialog();
          }
        });
      }
    }
  }

  void _move(int dRow, int dCol) {
    if (_levelCompleted) return;
    setState(() {
      bool moved = _gameState.movePlayer(dRow, dCol);
      if (moved && _gameState.checkWinCondition()) {
        _levelCompleted = true;
        _showWinDialog();
      }
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Nivel Completado!'),
        content: Text(
          '¡Genial ${widget.playerName}!, has desbloqueado nuestro video de TikTok\n\n¿Quieres verlo ya?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VideoScreen(playerName: widget.playerName),
                ),
              );
            },
            child: const Text('Ver'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _gameState = GameState();
                _levelCompleted = false;
              });
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(int cellValue, double cellSize) {
    if (cellValue == 5 || cellValue == 6) {
      return Stack(
        children: [
          Image.asset(
            'assets/images/suelo.png',
            fit: BoxFit.cover,
            width: cellSize,
            height: cellSize,
          ),
          if (cellValue == 6)
            Image.asset(
              'assets/images/meta.png',
              fit: BoxFit.cover,
              width: cellSize,
              height: cellSize,
            ),
          Center(
            child: AnimatedSprite(
              imagePath: 'assets/images/Idle (32x32).png',
              totalFrames: 11,
              frameWidth: cellSize * 0.75,
              frameHeight: cellSize * 0.75,
            ),
          ),
        ],
      );
    }

    String imagePath = '';
    bool showSueloBg = true;

    switch (cellValue) {
      case 0:
        imagePath = 'assets/images/suelo.png';
        showSueloBg = false;
        break;
      case 1:
        imagePath = 'assets/images/paredcentro.png';
        showSueloBg = false;
        break;
      case 2:
        imagePath = 'assets/images/caja.png';
        break;
      case 3:
        imagePath = 'assets/images/meta.png';
        break;
      case 4:
        imagePath = 'assets/images/caja.png';
        break;
    }

    return Stack(
      children: [
        if (showSueloBg)
          Image.asset(
            'assets/images/suelo.png',
            fit: BoxFit.cover,
            width: cellSize,
            height: cellSize,
          ),
        if (imagePath.isNotEmpty)
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: cellSize,
            height: cellSize,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mapWidth = _gameState.map[0].length;
    final mapHeight = _gameState.map.length;
    final maxCellSizeByWidth = size.width / (mapWidth + 2);
    final maxCellSizeByHeight = (size.height - 160) / mapHeight;
    final cellSize = maxCellSizeByWidth < maxCellSizeByHeight
        ? maxCellSizeByWidth
        : maxCellSizeByHeight;
    final double actualCellSize = cellSize < 18 ? 18.0 : cellSize.toDouble();

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        _handleKeyEvent(event);
        return KeyEventResult.handled;
      },
      child: Scaffold(
        backgroundColor: Colors.brown.shade100,
        appBar: AppBar(
          title: const Text('Team - Manos Verdes'),
          backgroundColor: const Color(0xFF2EB082),
          foregroundColor: Colors.white,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _gameState = GameState();
                  _levelCompleted = false;
                });
              },
              tooltip: 'Reiniciar',
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.brown.shade400,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _gameState.map.map((row) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: row.map((cell) {
                                return SizedBox(
                                  width: actualCellSize,
                                  height: actualCellSize,
                                  child: _buildCell(cell, actualCellSize),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text(
                      'Empuja las cajas hacia la única meta',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        IconButton.filled(
                          onPressed: () => _move(-1, 0),
                          icon: const Icon(Icons.keyboard_arrow_up),
                          iconSize: 36,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF2EB082),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton.filled(
                              onPressed: () => _move(0, -1),
                              icon: const Icon(Icons.keyboard_arrow_left),
                              iconSize: 36,
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF2EB082),
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 60),
                            IconButton.filled(
                              onPressed: () => _move(0, 1),
                              icon: const Icon(Icons.keyboard_arrow_right),
                              iconSize: 36,
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF2EB082),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        IconButton.filled(
                          onPressed: () => _move(1, 0),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 36,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF2EB082),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
