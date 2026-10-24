enum CellType { empty, wall, box, target, boxOnTarget, player, playerOnTarget }

class GameState {
  List<List<int>> map = [
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 2, 0, 1, 0, 1, 2, 1, 2, 0, 1],
    [1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1],
    [1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1],
    [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 2, 0, 0, 1, 2, 1, 0, 1, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1],
    [1, 5, 0, 0, 0, 0, 0, 2, 0, 0, 3, 1],
    [1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1],
    [1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  ];

  int playerRow = 0;
  int playerCol = 0;
  int boxesTotal = 0;
  int boxesPlaced = 0;

  GameState() {
    _countBoxes();
    _findPlayerPosition();
  }

  void _countBoxes() {
    boxesTotal = 0;
    for (int r = 0; r < map.length; r++) {
      for (int c = 0; c < map[r].length; c++) {
        if (map[r][c] == 2 || map[r][c] == 4) {
          boxesTotal++;
        }
      }
    }
  }

  void _findPlayerPosition() {
    for (int r = 0; r < map.length; r++) {
      for (int c = 0; c < map[r].length; c++) {
        if (map[r][c] == 5 || map[r][c] == 6) {
          playerRow = r;
          playerCol = c;
        }
      }
    }
  }

  bool movePlayer(int dRow, int dCol) {
    int nextRow = playerRow + dRow;
    int nextCol = playerCol + dCol;

    if (nextRow < 0 ||
        nextRow >= map.length ||
        nextCol < 0 ||
        nextCol >= map[0].length) {
      return false;
    }

    if (map[nextRow][nextCol] == 1) return false;

    if (map[nextRow][nextCol] == 2 || map[nextRow][nextCol] == 4) {
      int beyondRow = nextRow + dRow;
      int beyondCol = nextCol + dCol;

      if (beyondRow < 0 ||
          beyondRow >= map.length ||
          beyondCol < 0 ||
          beyondCol >= map[0].length) {
        return false;
      }

      if (map[beyondRow][beyondCol] == 0) {
        map[beyondRow][beyondCol] = 2;
        map[nextRow][nextCol] = (map[nextRow][nextCol] == 4) ? 3 : 0;
      } else if (map[beyondRow][beyondCol] == 3) {
        // Caja desaparece, meta permanece
        map[beyondRow][beyondCol] = 3;
        map[nextRow][nextCol] = (map[nextRow][nextCol] == 4) ? 3 : 0;
        boxesPlaced++;
      } else {
        return false;
      }
    }

    map[playerRow][playerCol] = (map[playerRow][playerCol] == 6) ? 3 : 0;

    playerRow = nextRow;
    playerCol = nextCol;
    map[playerRow][playerCol] = (map[playerRow][playerCol] == 3) ? 6 : 5;

    return true;
  }

  bool checkWinCondition() {
    if (boxesTotal == 0) return false;
    return boxesPlaced >= boxesTotal;
  }
}
