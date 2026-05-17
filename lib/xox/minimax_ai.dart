import 'dart:math';

class MinimaxAI {
  // AI'ın hamle kararını verdiği ana fonksiyon
  int getBestMove(List<String> board, Function(List<String>) checkWinner, int errorRate) {
    List<int> availableMoves = [];
    
    // Tahtadaki boş hücrelerin indekslerini bul ve listeye ekle
    for (int i = 0; i < board.length; i++) {
      if (board[i] == "") {
        availableMoves.add(i);
      }
    }

    // Tahta tamamen doluysa -1 döndür (Hata kontrolü)
    if (availableMoves.isEmpty) return -1;

    // --- ZORLUK SEVİYESİ (%30 İHTİMALLE HATA YAPMA) ---
Random random = Random();
  int chance = random.nextInt(100); 
  
  // BURASI KRİTİK: errorRate artık dışarıdan (arayüzden) geliyor.
  if (chance < errorRate) {
    print("AI Hata Yaptı! (Zorluk: %$errorRate hata payı)");
    int randomIndex = random.nextInt(availableMoves.length);
    return availableMoves[randomIndex];
  }

    // --- %70 İHTİMALLE: MİNİMAX İLE KUSURSUZ HAMLE ---
    print("AI Düşünüyor... (Minimax Devrede)");
    int bestScore = -10000;
    int bestMove = -1;

    // Tüm boş hücreleri tek tek dene
    for (int i = 0; i < availableMoves.length; i++) {
      int index = availableMoves[i];
      
      // 1. Hamleyi simüle et (Sanki AI 'O' oynamış gibi yap)
      board[index] = "O";
      
      // 2. Bu hamlenin sonucunda oyunun ne kadar iyiye gideceğini hesapla
      int score = _minimax(board, 0, false, checkWinner);
      
      // 3. Tahtayı eski haline getir (Simülasyon bitti)
      board[index] = "";

      // 4. Eğer bu hamle önceki en iyi hamleden daha yüksek skor verdiyse, yeni en iyi hamle yap
      if (score > bestScore) {
        bestScore = score;
        bestMove = index;
      }
    }

    return bestMove; // Bulunan en iyi indeks numarasını ekrana gönder
  }

  // İşin kalbi: Minimax özyinelemeli (recursive) algoritması
  int _minimax(List<String> board, int depth, bool isMaximizing, Function(List<String>) checkWinner) {
    String result = checkWinner(board);
    
    // Kazanma/Kaybetme durumlarına göre puanlama (Derinlik hesabı eklendi)
    if (result == "O") return 10 - depth; // AI ne kadar erken kazanırsa o kadar iyi (+)
    if (result == "X") return depth - 10; // Oyuncu ne kadar geç kazanırsa AI için o kadar az kötü (-)
    if (result == "Draw") return 0;       // Beraberlik nötr durum

    if (isMaximizing) {
      // AI'ın Sırası (Skoru Maksimize Etmeye Çalışır)
      int bestScore = -10000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == "") {
          board[i] = "O";
          int score = _minimax(board, depth + 1, false, checkWinner);
          board[i] = "";
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      // Oyuncunun Sırası (Skoru Minimize Etmeye Çalışır - Oyuncu zekiymiş gibi düşünür)
      int bestScore = 10000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == "") {
          board[i] = "X";
          int score = _minimax(board, depth + 1, true, checkWinner);
          board[i] = "";
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }
}