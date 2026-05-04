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
        title: const Text('Bölüm Tamamlandı!'),
        content: const Text('Harika iş çıkardın. Sıradaki labirente geçiliyor...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
              _controller.loadNextMaze(); // Tamam'a basınca resetGame DEĞİL, sonraki labirenti yükle
            },
            child: const Text('Sonraki Bölüm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Labirent Kaçış'),
        backgroundColor: Colors.blueGrey,
        actions: [
          // Sağ üst köşedeki yuvarlak yenileme/değiştirme butonu
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Farklı Labirent Yükle',
            onPressed: () {
              _controller.loadNextMaze();
            },
          ),
          const SizedBox(width: 8), // Sağdan hafif boşluk
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Column(
            children: [
              // Hangi seviyede olduğumuzu gösteren küçük bir bilgi yazısı
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Seviye ${_controller.currentMazeIndex + 1}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
              ),
              
              Expanded(
                child: Center(
                  child: MazeGridBoard(maze: _controller.maze),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      print("A* Algoritması başlatılıyor...");
                    },
                    child: const Text(
                      'Bana Yolu Göster',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
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