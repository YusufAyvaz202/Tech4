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
  // Sıranın oyuncuda (X) olup olmadığını tutan değişken
  bool isPlayerTurn = true;

void _makeMove(int index) {
    if (board[index] != "") return;

    setState(() {
      board[index] = isPlayerTurn ? "X" : "O";
      isPlayerTurn = !isPlayerTurn;
    });

    // Her hamleden sonra tahtanın güncel halini gönderip kazanan var mı diye bakıyoruz
    String winner = checkWinner(board);
    
    // Eğer kazanan varsa veya berabere bittiyse dialog penceresini çağırıyoruz
    if (winner != "") {
      _showGameOverDialog(winner);
    }
  }

  // Kazanma durumunu kontrol eden metodumuz
  String checkWinner(List<String> currentBoard) {
    // Tüm kazanma ihtimallerinin (yan yana, alt alta, çapraz) indeksleri
    List<List<int>> winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Yatay (Satırlar)
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Dikey (Sütunlar)
      [0, 4, 8], [2, 4, 6]             // Çaprazlar
    ];

    // Bütün kazanma ihtimallerini tek tek döngüye sokup kontrol ediyoruz
    for (var condition in winConditions) {
      String a = currentBoard[condition[0]];
      String b = currentBoard[condition[1]];
      String c = currentBoard[condition[2]];

      // Eğer üç hücre de boş değilse ve birbirinin aynısıysa ("X" veya "O")
      if (a != "" && a == b && a == c) {
        return a; // Kazananı döndür ("X" veya "O")
      }
    }

    // Eğer kazanan yoksa ve tahtada hiç boş yer kalmadıysa beraberliktir
    if (!currentBoard.contains("")) {
      return "Draw"; // Beraberlik
    }

    // Oyun hala devam ediyorsa boş metin döndür
    return ""; 
  }

  // Oyunu sıfırlayan fonksiyon
  void _resetGame() {
    setState(() {
      board = List.filled(9, ""); // Tahtayı temizle
      isPlayerTurn = true;        // Sırayı tekrar oyuncuya (X) ver
    });
  }

  // Kazananı ekranda gösteren diyalog penceresi
  void _showGameOverDialog(String winner) {
    String title = "";
    if (winner == "Draw") {
      title = "Berabere!";
    } else {
      title = "$winner Kazandı!";
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Ekranda boş bir yere tıklayarak kapatmayı engeller
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: const Text("Tekrar oynamak ister misin?", style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Diyalog penceresini kapat
                _resetGame(); // Oyunu sıfırla
              },
              child: const Text("Yeniden Başlat", style: TextStyle(color: Colors.tealAccent)),
            ),
          ],
        );
      },
    );
  }

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
// En baştaki const kelimesini kaldırdık
        Padding(
          padding: const EdgeInsets.all(16.0), // const'u sadece bu sabit değere verdik
          child: Text(
            isPlayerTurn ? "Sıra: X" : "Sıra: O",
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                  _makeMove(index); // Artık print yerine yazdığımız fonksiyonu çağırıyoruz
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