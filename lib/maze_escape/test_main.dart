import 'package:flutter/material.dart';
import 'frontend/maze_escape_screen.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Maze Escape Test',
    debugShowCheckedModeBanner: false,
    home: MazeEscapeScreen(),
  ));
}