import 'package:flutter/material.dart';
import 'app_colors.dart';

class ScoreBoardWidget extends StatelessWidget {
  final int playerScore;
  final int aiScore;

  const ScoreBoardWidget({super.key, required this.playerScore, required this.aiScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.mutedCharcoal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.coolGrey, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("YOU", style: TextStyle(color: AppColors.neonCoral, fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 50),
              Text("AI", style: TextStyle(color: AppColors.electricTeal, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$playerScore", style: const TextStyle(color: AppColors.offWhite, fontSize: 32, fontWeight: FontWeight.bold)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("-", style: TextStyle(color: AppColors.slateGrey, fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              Text("$aiScore", style: const TextStyle(color: AppColors.offWhite, fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}