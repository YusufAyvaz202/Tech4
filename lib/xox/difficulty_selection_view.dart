import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'difficulty_button.dart';

class DifficultySelectionView extends StatelessWidget {
  final Function(String, int) onDifficultySelected;

  const DifficultySelectionView({super.key, required this.onDifficultySelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Image.asset('assets/images/xox_logoo.png', height: 180, fit: BoxFit.contain),
          ),
          const SizedBox(height: 30),
          const Text("AI vs YOU", style: TextStyle(color: AppColors.offWhite, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 10),
          const Text("Test your limits", style: TextStyle(color: AppColors.slateGrey, fontSize: 16, fontStyle: FontStyle.italic)),
          const SizedBox(height: 60),
          const Text("Select Difficulty Level", style: TextStyle(color: AppColors.offWhite, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          DifficultyButton(name: "EASY", errorRate: 60, color: AppColors.electricTeal, onTap: () => onDifficultySelected("EASY", 60)),
          DifficultyButton(name: "HARD", errorRate: 30, color: AppColors.slateGrey, onTap: () => onDifficultySelected("HARD", 30)),
          DifficultyButton(name: "IMPOSSIBLE", errorRate: 0, color: AppColors.neonCoral, onTap: () => onDifficultySelected("IMPOSSIBLE", 0)),
          
          const SizedBox(height: 40),
          TextButton.icon(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            icon: const Icon(Icons.arrow_back, color: AppColors.slateGrey),
            label: const Text("Back to Main Menu", style: TextStyle(color: AppColors.slateGrey)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}