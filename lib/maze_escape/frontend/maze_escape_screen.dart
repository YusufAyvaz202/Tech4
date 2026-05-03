import 'package:flutter/material.dart';

class MazeEscapeScreen extends StatefulWidget {
  const MazeEscapeScreen({Key? key}) : super(key: key);

  @override
  State<MazeEscapeScreen> createState() => _MazeEscapeScreenState();
}

class _MazeEscapeScreenState extends State<MazeEscapeScreen> {
  // 10x10 örnek bir labirent matrisi
  // 0: Yol, 1: Duvar, 2: Başlangıç (S), 3: Çıkış (E)
  final List<List<int>> maze = [
    [2, 0, 0, 1, 0, 0, 0, 1, 0, 0],
    [1, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
    [1, 1, 1, 1, 0, 1, 1, 0, 1, 0],
    [0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
    [0, 1, 0, 1, 1, 0, 1, 1, 1, 1],
    [0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 0, 3], 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maze Escape'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1, // Ekranı tam kare yapar
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(), // Kaydırmayı kapat
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: maze[0].length, // Sütun sayısı (10)
                    ),
                    itemCount: maze.length * maze[0].length, // Toplam kare sayısı (100)
                    itemBuilder: (context, index) {
                      // 1D index'i 2D matris koordinatlarına (satır, sütun) çevirme
                      int row = index ~/ maze[0].length;
                      int col = index % maze[0].length;
                      int cellValue = maze[row][col];

                      Color cellColor;
                      if (cellValue == 1) {
                        cellColor = Colors.black87; // Duvar
                      } else if (cellValue == 2) {
                        cellColor = Colors.green; // Başlangıç (S)
                      } else if (cellValue == 3) {
                        cellColor = Colors.red; // Çıkış (E)
                      } else {
                        cellColor = Colors.white; // Yol
                      }

                      return Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                          color: cellColor,
                          border: Border.all(color: Colors.grey.shade300, width: 0.5),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          
          // Yapay Zeka Tetikleyici Buton
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
                  // TODO: A* algoritması burada çalışacak ve rotayı çizecek
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
      ),
    );
  }
}