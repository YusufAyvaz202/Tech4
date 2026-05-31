import 'package:flutter/material.dart';
import '../controllers/maze_game_controller.dart';
import '../widgets/maze_grid_board.dart';
import '../widgets/d_pad_controls.dart';

class MazeEscapeScreen extends StatefulWidget {
  const MazeEscapeScreen({super.key});

  @override
  State<MazeEscapeScreen> createState() => _MazeEscapeScreenState();
}

class _MazeEscapeScreenState extends State<MazeEscapeScreen> {
  final MazeGameController _controller = MazeGameController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.isGameWon) {
        _showWinDialog();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2640), // Dialog Zemini: Muted Charcoal
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF3A4454), width: 2),
        ), 
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: Color(0xFFFF6B6B), size: 32), // Neon Coral Kupa
            SizedBox(width: 8),
            Text('Congratulations!', style: TextStyle(color: Color(0xFFF8FAFC))), // Off-White
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You successfully completed the maze in ${_controller.currentSteps} steps!',
              style: const TextStyle(fontSize: 16, color: Color(0xFF94A3B8)), // Slate Grey
            ),
            const SizedBox(height: 16), 
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF121826), // Kutu Zemini: Deep Slate
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF3A4454)), // Çerçeve: Cool Grey
              ),
              child: Row(
                children: [
                  const Icon(Icons.psychology, color: Color(0xFF00F5D4), size: 28), // Electric Teal
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'A* The Perfect Solution: ${_controller.optimalSteps} steps',
                      style: const TextStyle(
                        fontSize: 14, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFF00F5D4), // Electric Teal
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
              _controller.loadNextMaze(); 
            },
            child: const Text('Next Level', style: TextStyle(fontSize: 16, color: Color(0xFF00F5D4))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121826), // Ana Arka Plan: Deep Slate
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Color(0xFFF8FAFC)), // Off-White
          tooltip: 'Back to Main Menu',
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: const Text('Maze Escape', style: TextStyle(color: Color(0xFFF8FAFC))),
        backgroundColor: const Color(0xFF1E2640), // Muted Charcoal
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFF8FAFC)),
            tooltip: 'Load a Different Maze',
            onPressed: () {
              _controller.loadNextMaze();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level ${_controller.currentMazeIndex + 1}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFF8FAFC)), // Off-White
                    ),
                    Text(
                      'Steps: ${_controller.currentSteps}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00F5D4)), // Electric Teal
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Center(
                  child: MazeGridBoard(
                    maze: _controller.maze, 
                    hintPath: _controller.hintPath,
                  ),
                ),
              ),
              
              DPadControls(
                onUp: () => _controller.movePlayer(-1, 0),
                onDown: () => _controller.movePlayer(1, 0),
                onLeft: () => _controller.movePlayer(0, -1),
                onRight: () => _controller.movePlayer(0, 1),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2640), // Muted Charcoal
                      foregroundColor: const Color(0xFF00F5D4), // Electric Teal
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFF3A4454)), // Cool Grey çerçeve
                      ),
                    ),
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text(
                      'Get Hint',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _controller.getHint(); 
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}