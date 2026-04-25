import 'package:chess_game/models/pieces/piece.dart';
import 'package:chess_game/models/position.dart';

class Pawn implements Piece {
  @override final String color;
  @override Position position;
  @override late String assetPath;
  @override bool alreadyMoved;
  static const List<List<int>> steps = [[0, 1], [0, 2], [1, 1], [-1, 1]];
  

  Pawn(this.color, this.position, {this.alreadyMoved = false}) {
    assetPath = _getImage();
  }

  @override
  List<Position> possiblePositions() {
    List<Position> positions = [];

    for (List<int> step in steps) {
      Position? newPosition;

      newPosition = position.move(step[0], step[1]);

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
      case 'white': return 'lib/assets/white_pawn.png';

      case 'black': return 'lib/assets/black_pawn.png';

      default: return ''; 
    } 
  }
}