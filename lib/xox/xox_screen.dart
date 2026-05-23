import 'package:flutter/material.dart';
import 'minimax_ai.dart';

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
  MinimaxAI ai = MinimaxAI();
  // YENİ EKLENECEK DEĞİŞKENLER:
  int? selectedErrorRate; // null ise seçim ekranındayız, değer varsa oyun ekranındayız.
  String selectedDifficultyName = ""; // Ekranda hangi modda olduğumuzu yazmak için. // Yapay zeka motorumuzu başlattık
  List<int> winningLine = [];
  int playerScore = 0;
  int aiScore = 0;

void _makeMove(int index) async {
    // 1. KORUMA: Eğer hücre doluysa veya sıra sende değilse (AI düşünüyorsa) tıklamayı yoksay
    if (board[index] != "" || !isPlayerTurn) return;

    // 2. OYUNCUNUN HAMLESİ
    setState(() {
      board[index] = "X";
      isPlayerTurn = false; // Sırayı AI'a geçiriyoruz
    });

    // Oyuncunun hamlesi sonrası oyun bitti mi kontrolü
    String winner = checkWinner(board);
    if (winner != "") {
      _showGameOverDialog(winner);
      return; // Oyun bittiyse fonksiyonu burada kes, AI hamle yapmasın
    }

    // 3. YAPAY ZEKANIN HAMLESİ
    // AI'ın "düşünüyormuş" hissi vermesi için yarım saniyelik (500ms) yapay bir bekleme süresi ekliyoruz.
    await Future.delayed(const Duration(milliseconds: 500));

    // AI'a mevcut tahtayı ve kazananı anlama fonksiyonumuzu verip en iyi hamleyi soruyoruz
    int aiMove = ai.getBestMove(board, checkWinner, selectedErrorRate!);

    // Eğer AI yapacak geçerli bir hamle bulduysa
    if (aiMove != -1) {
      setState(() {
        board[aiMove] = "O";
        isPlayerTurn = true; // Sırayı tekrar oyuncuya devret
      });

      // AI'ın hamlesi sonrası oyun bitti mi kontrolü
      winner = checkWinner(board);
      if (winner != "") {
        _showGameOverDialog(winner);
      }
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
      isPlayerTurn = true;
      winningLine = [];        
    });
  }

  // Kazanan kombinasyonun indislerini bularak winningLine listesine kaydeder
  void _setWinningLine() {
    List<List<int>> winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Yatay
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Dikey
      [0, 4, 8], [2, 4, 6]             // Çapraz
    ];
    
    for (var condition in winConditions) {
      String a = board[condition[0]];
      // Eğer hücre boş değilse ve üçü de aynıysa kazanan çizgiyi bulduk demektir
      if (a != "" && a == board[condition[1]] && a == board[condition[2]]) {
        setState(() {
          winningLine = condition; // Durumu güncelle ve arayüzü tetikle
        });
        break;
      }
    }
  }

  // Kazananı ekranda gösteren diyalog penceresi
void _showGameOverDialog(String winner) {
    String title = "";
    
    // Hem skoru artırıyoruz hem de mesajı tek bir yerde belirliyoruz
    setState(() {
      if (winner == "Draw") {
        title = "Berabere!";
      } else if (winner == "X") {
        title = "Sen Kazandın!";
        playerScore++;
      } else if (winner == "O") {
        title = "AI Kazandı!";
        aiScore++;
      }
      
      // Kazanan varsa çizgiyi renklendir
      if (winner != "Draw") {
        _setWinningLine();
      }
    });

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

Widget _buildSelectionScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Zorluk Seviyesi Seç",
          style: TextStyle(
            color: Colors.white, 
            fontSize: 28, 
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 40),
        _difficultyButton("KOLAY", 60, Colors.green),
        _difficultyButton("ZOR", 30, Colors.orange),
        _difficultyButton("İMKANSIZ", 0, Colors.red),
        const SizedBox(height: 60),
        // Diğer dersle birleştiğinde kullanılacak "Ana Menüye Dön" butonu için yerimiz hazır
        TextButton.icon(
          onPressed: () { 
            /* Navigator.pop(context); - Diğer oyunlarla birleşince açılacak */ 
          },
          icon: const Icon(Icons.arrow_back, color: Colors.tealAccent),
          label: const Text(
            "Ana Menüye Dön", 
            style: TextStyle(color: Colors.tealAccent)
          ),
        ),
      ],
    );
  }

  Widget _difficultyButton(String name, int rate, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
        ),
        onPressed: () {
          setState(() {
            selectedErrorRate = rate;
            selectedDifficultyName = name;
          });
        },
        child: Text(
          name, 
          style: const TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: Colors.white
          )
        ),
      ),
    );
  }

Widget _buildGameScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // İŞTE YENİ SKOR TABLOMUZ
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  const Text("SEN", style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("$playerScore", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("-", style: TextStyle(color: Colors.white54, fontSize: 32)),
              ),
              Column(
                children: [
                  const Text("AI", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("$aiScore", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),

        // Sıra Göstergesi
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            isPlayerTurn ? "Sıra: Sen" : "Sıra: AI",
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        
        // 3x3 Oyun Tahtası
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _makeMove(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: winningLine.contains(index) ? Colors.green[700] : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: AnimatedScale(
                        // DURUM KONTROLÜ: Eğer hücre boşsa boyut 0'dır (görünmez). 
                        // Hamle yapıldığı an otomatik olarak 1 (tam boy) boyutuna animasyonla büyür.
                        scale: board[index] == "" ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 300), // Animasyonun süresi (300 milisaniye)
                        curve: Curves.bounceOut, // Sıçrama/Esneklik efekti veren eğri
                        child: Text(
                          board[index],
                          style: TextStyle(
                            color: board[index] == "X" ? Colors.blueAccent : Colors.redAccent, 
                            fontSize: 60, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // İŞTE YENİ "ZORLUK SEÇİMİNE DÖN" BUTONUMUZ
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0), 
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                selectedErrorRate = null; // null yaparak zorluk seçim ekranına dönüyoruz
                playerScore = 0;
                aiScore = 0;
                _resetGame(); // Oyun tahtasını sıfırlıyoruz
              });
            },
            icon: const Icon(Icons.settings_backup_restore, color: Colors.tealAccent),
            label: const Text("Zorluk Seçimine Dön", style: TextStyle(color: Colors.tealAccent)),
          ),
        ),
      ],
    );
  }




  // 2. ADIM: Uygulamanın ana vitrini (Hangi ekranın açılacağını kontrol eder)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], 
      appBar: AppBar(
        // Zorluk seçilmediyse genel başlık, seçildiyse aktif modu üstte yazar
        title: Text(selectedErrorRate == null ? 'Tic Tac Toe' : 'Mod: $selectedDifficultyName'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      // Seçim yapıldıysa oyun ekranını, yapılmadıysa zorluk seçme ekranını gösterir
      body: selectedErrorRate == null 
          ? _buildSelectionScreen() 
          : _buildGameScreen(),
    );
  }
}