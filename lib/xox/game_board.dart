import 'package:flutter/material.dart';
import 'app_colors.dart';

class GameBoardWidget extends StatelessWidget {
  final List<String> board;
  final List<int> winningLine;
  final Function(int) onMove;

  const GameBoardWidget({super.key, required this.board, required this.winningLine, required this.onMove});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.coolGrey,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => onMove(index),
                    child: Container(
                      color: winningLine.contains(index) ? AppColors.coolGrey.withOpacity(0.9) : AppColors.mutedCharcoal,
                      child: Center(
                        child: AnimatedScale(
                          scale: board[index] == "" ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.bounceOut,
                          child: Text(
                            board[index],
                            style: TextStyle(
                              color: board[index] == "X" ? AppColors.neonCoral : AppColors.electricTeal,
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
    );
  }
}