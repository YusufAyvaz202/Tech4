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
  // --- YENİ TEMA RENK PALETİ ---
  final Color deepSlate = const Color(0xFF121826);
  final Color mutedCharcoal = const Color(0xFF1E2640);
  final Color coolGrey = const Color(0xFF3A4454);
  final Color neonCoral = const Color(0xFFFF6B6B);
  final Color electricTeal = const Color(0xFF00F5D4);
  final Color offWhite = const Color(0xFFF8FAFC);
  final Color slateGrey = const Color(0xFF94A3B8);

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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Image.asset('assets/images/xox_logoo.png', height: 180, fit: BoxFit.contain),
        ),
        const SizedBox(height: 30),

        Text(
          "YAPAY ZEKA vs SEN",
          style: TextStyle(color: offWhite, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        const SizedBox(height: 10),
        Text(
          "Kendi sınırlarını test et",
          style: TextStyle(color: slateGrey, fontSize: 16, fontStyle: FontStyle.italic),
        ),
        
        const SizedBox(height: 60),

        Text(
          "Zorluk Seviyesi Seç",
          style: TextStyle(color: offWhite, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        
        // Buton renklerini yeni temamıza uyarladık
        _difficultyButton("KOLAY", 60, electricTeal),
        _difficultyButton("ZOR", 30, slateGrey),
        _difficultyButton("İMKANSIZ", 0, neonCoral),
        
        const SizedBox(height: 40),
        
        TextButton.icon(
          onPressed: () { /* Navigator.pop(context); */ },
          icon: Icon(Icons.arrow_back, color: slateGrey),
          label: Text("Ana Menüye Dön", style: TextStyle(color: slateGrey)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // --- PREMIUM BUTON TASARIMI (Güncelleme) ---
  // Eski düz butonumuzu, koyu arka planlı ve renkli çerçeveli (Border) hale getirdik
Widget _difficultyButton(String name, int rate, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: OutlinedButton( 
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 2), 
          backgroundColor: color.withOpacity(0.1), 
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          setState(() {
            selectedErrorRate = rate;
            selectedDifficultyName = name;
          });
        },
        child: Text(
          name, 
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)
        ),
      ),
    );
  }



Widget _buildGameScreen() {
    Color modeColor = selectedDifficultyName == "İMKANSIZ" 
        ? neonCoral 
        : (selectedDifficultyName == "KOLAY" ? electricTeal : slateGrey);
        
    return SizedBox(
      width: double.infinity, // Sütunun ekranın %100 genişliğini kaplamasını zorunlu kılar
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, // Yatayda her şeyi tam ortaya hizalar
        children: [
          // --- BAŞLIK VE DİNAMİK MOD ROZETİ ---
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
            child: Column(
              children: [
                // 1. Oyun Adı (Şık ve ayrık harfler)
                Text(
                  "TIC-TAC-TOE",
                  style: TextStyle(
                    color: offWhite,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.0, // Harflerin arasını havalı durması için açtık
                  ),
                ),
                const SizedBox(height: 10),
                // 2. Mod Rozeti (Seçilen zorluğa göre renk değiştiren çerçeve)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: mutedCharcoal,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: modeColor, width: 1.5),
                  ),
                  child: Text(
                    "MOD: $selectedDifficultyName",
                    style: TextStyle(
                      color: modeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // --- TEMATİK SKOR TABLOSU (Hizalama Düzeltildi) ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            decoration: BoxDecoration(
              color: mutedCharcoal, 
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: coolGrey, width: 2), 
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), 
                  blurRadius: 20, 
                  offset: const Offset(0, 10)
                ),
              ],
            ),
            // Yamukluğu önlemek için Sütunlar (Column) yerine Satırları (Row) alt alta dizdik
            child: Column(
              children: [
                // 1. SATIR: İSİMLER
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("SEN", style: TextStyle(color: neonCoral, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 50), // İsimlerin aralığı
                    Text("AI", style: TextStyle(color: electricTeal, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 5), // İsimler ve rakamlar arası minik boşluk
                // 2. SATIR: SKORLAR
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$playerScore", style: TextStyle(color: offWhite, fontSize: 32, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text("-", style: TextStyle(color: slateGrey, fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
                    Text("$aiScore", style: TextStyle(color: offWhite, fontSize: 32, fontWeight: FontWeight.bold)),
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
              style: TextStyle(color: offWhite, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          
          // --- 3x3 OYUN TAHTASI (Muted Charcoal Kart ve Cool Grey Izgara) ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0), // Dışarıdan şık bir boşluk
              child: AspectRatio(
                aspectRatio: 1.0, // Tahtanın tam bir kare kart olmasını garanti ediyoruz
                child: Container(
                  padding: const EdgeInsets.all(4), // Dış çerçevenin Cool Grey inceliği (ızgara çizgileri zemini)
                  decoration: BoxDecoration(
                    color: coolGrey, // Izgara çizgilerinin rengi (Zemin)
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      // Zeminle uyumlu ama belirgin bir gölge
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8), 
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16), // İç hücrelerin taşmasını engeller
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(), // Kaydırmayı kapatıyoruz
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 6, // Yatay Cool Grey çizgilerin kalınlığı
                        mainAxisSpacing: 6,  // Dikey Cool Grey çizgilerin kalınlığı
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _makeMove(index);
                          },
                          child: Container(
                            // Hücrelerin kendisi de Muted Charcoal kart renginde
                            color: winningLine.contains(index) ? coolGrey.withOpacity(0.9) : mutedCharcoal,
                            child: Center(
                              child: AnimatedScale(
                                scale: board[index] == "" ? 0.0 : 1.0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.bounceOut,
                                child: Text(
                                  board[index],
                                  style: TextStyle(
                                    // Sen (X) Neon Coral, AI (O) Electric Teal
                                    color: board[index] == "X" ? neonCoral : electricTeal, 
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
              ),
            ),
          ),

          // Zorluk Seçimine Dön Butonu
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0), 
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  selectedErrorRate = null;
                  playerScore = 0;
                  aiScore = 0;
                  _resetGame();
                });
              },
              icon: Icon(Icons.settings_backup_restore, color: slateGrey),
              label: Text("Zorluk Seçimine Dön", style: TextStyle(color: slateGrey)),
            ),
          ),
        ],
      ),
    );
  }




  // 2. ADIM: Uygulamanın ana vitrini (Hangi ekranın açılacağını kontrol eder)
@override
  Widget build(BuildContext context) {
    return Scaffold(
      // İŞTE BURASI: O büyük siyah alanı yok edip, tahta ile ekranı aynı renkte bütünleştiriyoruz
      backgroundColor: mutedCharcoal, 
      body: SafeArea(
        child: selectedErrorRate == null ? _buildSelectionScreen() : _buildGameScreen(),
      ),
    );
  }
}