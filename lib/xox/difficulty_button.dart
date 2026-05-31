import 'package:flutter/material.dart';

class DifficultyButton extends StatelessWidget {
  final String name;
  final int errorRate;
  final Color color;
  final VoidCallback onTap;

  const DifficultyButton({
    super.key, 
    required this.name, 
    required this.errorRate, 
    required this.color, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 2),
          backgroundColor: color.withOpacity(0.1),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: onTap,
        child: Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}