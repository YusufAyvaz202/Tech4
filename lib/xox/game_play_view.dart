import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'score_board.dart';
import 'game_board.dart';

class GamePlayView extends StatelessWidget {
  final List<String> board;
  final bool isPlayerTurn;
  final String difficultyName;
  final int playerScore;
  final int aiScore;
  final List<int> winningLine;
  final Function(int) onMove;
  final VoidCallback onBackToMenu;

  const GamePlayView({
    super.key, 
    required this.board, 
    required this.isPlayerTurn, 
    required this.difficultyName, 
    required this.playerScore, 
    required this.aiScore, 
    required this.winningLine, 
    required this.onMove, 
    required this.onBackToMenu
  });

  @override
  Widget build(BuildContext context) {
    Color modeColor = difficultyName == "IMPOSSIBLE" 
        ? AppColors.neonCoral 
        : (difficultyName == "EASY" ? AppColors.electricTeal : AppColors.slateGrey);

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(modeColor),
          ScoreBoardWidget(playerScore: playerScore, aiScore: aiScore),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              isPlayerTurn ? "It's Your Turn" : "It's AI's Turn",
              style: const TextStyle(color: AppColors.offWhite, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          
          GameBoardWidget(board: board, winningLine: winningLine, onMove: onMove),

          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TextButton.icon(
              onPressed: onBackToMenu,
              icon: const Icon(Icons.settings_backup_restore, color: AppColors.slateGrey),
              label: const Text("Back to Difficulty Selection", style: TextStyle(color: AppColors.slateGrey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color modeColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: Column(
        children: [
          const Text("TIC-TAC-TOE", style: TextStyle(color: AppColors.offWhite, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 4.0)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.mutedCharcoal,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: modeColor, width: 1.5),
            ),
            child: Text("MOD: $difficultyName", style: TextStyle(color: modeColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ),
        ],
      ),
    );
  }
}