import 'package:flutter/material.dart';

// Bu sınıf senin oyununun ana vitrinidir.
class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({Key? key}) : super(key: key);

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  // Arka planda 9 hücrelik oyun tahtasını temsil edecek liste
  // Şimdilik hepsi boş ("")
  List<String> board = List.filled(9, "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Şık bir karanlık tema başlangıcı
      appBar: AppBar(
        title: const Text('Yapay Zeka vs Sen'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sıranın kimde olduğunu gösterecek alan (Şimdilik statik)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Sıra Sende (X)",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          
          // 3x3 Oyun Tahtası
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 sütun
                  crossAxisSpacing: 8, // Sütunlar arası boşluk
                  mainAxisSpacing: 8, // Satırlar arası boşluk
                ),
                itemCount: 9, // Toplam 9 kare
                itemBuilder: (context, index) {
                  // Her bir hücrenin tasarımı
                  return GestureDetector(
                    onTap: () {
                      // Tıklama olaylarını buraya yazacağız
                      print("$index. hücreye tıklandı!");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          board[index], // Liste boş olduğu için şimdilik boş görünecek
                          style: const TextStyle(color: Colors.white, fontSize: 48),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}