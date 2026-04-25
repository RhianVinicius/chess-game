import 'package:chess_game/models/pieces/piece.dart';
import 'package:chess_game/models/position.dart';

class Knight implements Piece {
  @override final String color;
  @override Position position;
  @override late String assetPath;
  @override bool alreadyMoved;
  static const List<List<int>> jumps = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]];

  Knight(this.color, this.position, {this.alreadyMoved = false}) {
    assetPath = _getImage();
  }

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

  @override
  void setPosition(Position newPosition) {
    position = newPosition; 
  }

  String _getImage() {
    switch (color) {
      case 'white': return 'lib/assets/white_knight.png';

      case 'black': return 'lib/assets/black_knight.png';

      default: return ''; 
    } 
  }
}