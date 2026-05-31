// lib/maze_escape/ai/a_star_pathfinder.dart

class AStarNode {
  final int row;
  final int col;
  int g; 
  int h; 
  AStarNode? parent; 

  AStarNode(this.row, this.col, {this.g = 0, this.h = 0, this.parent});

  int get f => g + h; 
}

class AStarPathfinder {
  static List<List<int>> findPath(List<List<int>> maze, int startR, int startC) {
    int targetR = -1, targetC = -1;
    for (int i = 0; i < maze.length; i++) {
      for (int j = 0; j < maze[i].length; j++) {
        if (maze[i][j] == 3) {
          targetR = i;
          targetC = j;
          break;
        }
      }
    }
    if (targetR == -1) return []; 

    List<AStarNode> openList = [];
    Set<String> closedList = {};

    openList.add(AStarNode(
      startR, startC, 
      h: _manhattanDistance(startR, startC, targetR, targetC)
    ));

    while (openList.isNotEmpty) {
      openList.sort((a, b) => a.f.compareTo(b.f));
      AStarNode current = openList.removeAt(0);
      
      closedList.add("${current.row}_${current.col}");

      if (current.row == targetR && current.col == targetC) {
        return _reconstructPath(current);
      }

      List<List<int>> directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];
      
      for (var dir in directions) {
        int newR = current.row + dir[0];
        int newC = current.col + dir[1];

        if (newR < 0 || newR >= maze.length || newC < 0 || newC >= maze[0].length) continue;
        if (maze[newR][newC] == 1) continue;
        if (closedList.contains("${newR}_${newC}")) continue;

        int tentativeG = current.g + 1; 
        int existingIndex = openList.indexWhere((n) => n.row == newR && n.col == newC);

        if (existingIndex == -1) {
          openList.add(AStarNode(
            newR, newC,
            g: tentativeG,
            h: _manhattanDistance(newR, newC, targetR, targetC),
            parent: current
          ));
        } else if (tentativeG < openList[existingIndex].g) {
          openList[existingIndex].g = tentativeG;
          openList[existingIndex].parent = current;
        }
      }
    }
    return []; 
  }

  static int _manhattanDistance(int r1, int c1, int r2, int c2) {
    return (r1 - r2).abs() + (c1 - c2).abs();
  }

  static List<List<int>> _reconstructPath(AStarNode? node) {
    List<List<int>> path = [];
    while (node != null) {
      path.add([node.row, node.col]);
      node = node.parent;
    }
    return path.reversed.toList();
  }
}