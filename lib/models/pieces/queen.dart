import 'package:chess_game/models/piece.dart';
import 'package:chess_game/models/position.dart';

class Queen implements Piece {
  @override final String color;
  @override Position position;
  static const List<List<int>> directions = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]];

  Queen(this.color, this.position);

  @override
  List<Position> possiblePositions() {
    List<Position> positions = [];

    for (List<int> direction in directions) {
      Position currentPosition = position;
      Position? newPosition;

      while (true) {
        newPosition = currentPosition.move(direction[0], direction[1]);

        if (newPosition == null) break;

        positions.add(newPosition);
        currentPosition = newPosition;
      }
    }
    return positions;
  }
}