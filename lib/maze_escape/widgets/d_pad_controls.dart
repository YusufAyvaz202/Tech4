import 'package:flutter/material.dart';

class DPadControls extends StatelessWidget {
  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const DPadControls({
    Key? key,
    required this.onUp,
    required this.onDown,
    required this.onLeft,
    required this.onRight,
  }) : super(key: key);

  Widget _buildButton(IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF1E2640), // Zemin: Muted Charcoal
        foregroundColor: const Color(0xFF00F5D4), // İkon: Electric Teal
        elevation: 4, // Hafif bir gölge
      ),
      onPressed: onPressed,
      child: Icon(icon, size: 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          _buildButton(Icons.keyboard_arrow_up, onUp),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(Icons.keyboard_arrow_left, onLeft),
              const SizedBox(width: 64),
              _buildButton(Icons.keyboard_arrow_right, onRight),
            ],
          ),
          _buildButton(Icons.keyboard_arrow_down, onDown),
        ],
      ),
    );
  }
}