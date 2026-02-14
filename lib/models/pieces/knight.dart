import 'package:chess_game/models/piece.dart';
import 'package:chess_game/models/position.dart';

class Knight implements Piece {
  @override final String color;
  @override Position position;
  static const List<List<int>> jumps = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]];

  Knight(this.color, this.position);

  @override
  List<Position> possiblePositions() {
    List<Position> positions = [];

    for (List<int> jump in jumps) {
      Position? newPosition;

      newPosition = position.move(jump[0], jump[1]);

      if (newPosition != null) positions.add(newPosition);
    }
    return positions;
  }
}