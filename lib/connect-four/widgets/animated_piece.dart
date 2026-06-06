import 'package:flutter/material.dart';

class AnimatedPiece extends StatelessWidget {
  final int player;
  final int row; 
  final bool isWinningPiece;
  final Color colorP1;
  final Color colorP2;
  final Color glowColor;

  const AnimatedPiece({
    super.key, 
    required this.player, 
    required this.row,
    required this.isWinningPiece,
    required this.colorP1,
    required this.colorP2,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    Color pieceColor = player == 1 ? colorP1 : colorP2;

    return TweenAnimationBuilder<Offset>(
      duration: Duration(milliseconds: 400 + (row * 80)), 
      curve: Curves.bounceOut, 
      tween: Tween<Offset>(
        begin: Offset(0, -(row + 2).toDouble()), 
        end: Offset.zero, 
      ),
      builder: (context, offset, child) {
        return FractionalTranslation(
          translation: offset,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: pieceColor,
          shape: BoxShape.circle,
          boxShadow: isWinningPiece 
              ? [
                  BoxShadow(
                    color: glowColor.withOpacity(0.8),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: pieceColor, 
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  )
                ],
        ),
      ),
    );
  }
}