import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/game_provider.dart';

class NumberPadWidget extends StatelessWidget {
  const NumberPadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 10, // 1-9 numbers + 1 Erase button
      itemBuilder: (context, index) {
        if (index == 9) {
          // Erase Button
          return ElevatedButton(
            onPressed: () => gameProvider.eraseNumber(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
            child: const Icon(Icons.backspace, color: Colors.red),
          );
        }

        // Number Buttons (1 to 9)
        int number = index + 1;
        return ElevatedButton(
          onPressed: () => gameProvider.inputNumber(number),
          child: Text(
            number.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}