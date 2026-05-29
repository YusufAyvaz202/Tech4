import 'package:flutter/material.dart';
import '../controllers/maze_game_controller.dart';
import '../widgets/maze_grid_board.dart';
import '../widgets/d_pad_controls.dart';

class MazeEscapeScreen extends StatefulWidget {
  const MazeEscapeScreen({Key? key}) : super(key: key);

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 32),
            SizedBox(width: 8),
            Text('Tebrikler!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Labirenti ${_controller.currentSteps} adımda başarıyla tamamladın!',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16), 
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.deepPurple.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.psychology, color: Colors.deepPurple, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'A* Algoritmasının Kusursuz Çözümü: ${_controller.optimalSteps} adım',
                      style: const TextStyle(
                        fontSize: 14, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.deepPurple,
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
            child: const Text('Sonraki Bölüm', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          tooltip: 'Ana Menüye Dön',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ana Menü modülü henüz entegre edilmedi.'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        title: const Text('Labirent Kaçış'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Farklı Labirent Yükle',
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
                      'Seviye ${_controller.currentMazeIndex + 1}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                    Text(
                      'Adım: ${_controller.currentSteps}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
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
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text(
                      'İpucu Ver',
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