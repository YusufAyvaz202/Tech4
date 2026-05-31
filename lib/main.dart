import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Game screen imports
import 'xox/xox_screen.dart';
import 'maze_escape/screens/maze_escape_screen.dart';
// Using aliases for screens with the same name to avoid conflicts
import 'connect-four/frontend/connect_four.dart' as c4; 
import 'sudoku/ui/game_screen.dart' as sudoku;
import 'sudoku/logic/game_provider.dart';

void main() {
  runApp(const OfflineGamesCollection());
}

class OfflineGamesCollection extends StatelessWidget {
  const OfflineGamesCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Games Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF121826),
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  // Global color palette shared across the games
  final Color bgDeepSlate = const Color(0xFF121826);
  final Color cardCharcoal = const Color(0xFF1E2640);
  final Color gridGrey = const Color(0xFF3A4454);
  final Color accentCoral = const Color(0xFFFF6B6B);
  final Color accentTeal = const Color(0xFF00F5D4);
  final Color textOffWhite = const Color(0xFFF8FAFC);
  final Color textSlate = const Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDeepSlate,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Text(
                'MINI GAMES',
                style: TextStyle(
                  color: accentTeal,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose Your\nChallenge',
                style: TextStyle(
                  color: textOffWhite,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 40),
              
              // Grid view for game selection
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.85,
                  children: [
                    _buildGameCard(
                      context: context,
                      title: 'Tic-Tac-Toe',
                      icon: Icons.grid_3x3_rounded,
                      color: accentCoral,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TicTacToeScreen()),
                      ),
                    ),
                    _buildGameCard(
                      context: context,
                      title: 'Connect Four',
                      icon: Icons.lens_blur_rounded,
                      color: accentTeal,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const c4.GameScreen()),
                      ),
                    ),
                    _buildGameCard(
                      context: context,
                      title: 'Maze Escape',
                      icon: Icons.route_rounded,
                      color: accentTeal,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MazeEscapeScreen()),
                      ),
                    ),
                    _buildGameCard(
                      context: context,
                      title: 'Sudoku AI',
                      icon: Icons.apps_rounded,
                      color: accentCoral,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          // Wrapping Sudoku with its required state provider
                          builder: (context) => ChangeNotifierProvider(
                            create: (_) => GameProvider(),
                            child: const sudoku.GameScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build consistent game cards
  Widget _buildGameCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardCharcoal,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: gridGrey.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floating icon inside a softly colored container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3), width: 2),
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                color: textOffWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Play Now',
              style: TextStyle(
                color: textSlate,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}