import 'package:chess_game/models/pieces/piece.dart';
import 'package:chess_game/models/position.dart';

class Bishop implements Piece {
  @override final String color;
  @override Position position;
  @override late String assetPath;
  @override bool alreadyMoved;
  static const List<List<int>> directions = [[1, 1], [1, -1], [-1, -1], [-1, 1]];


  Bishop(this.color, this.position, {this.alreadyMoved = false}) {
    assetPath = _getImage();
  }


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


  @override
  void setPosition(Position newPosition) {
    position = newPosition; 
  }


  String _getImage() {
    switch (color) {
      case 'white': return 'lib/assets/white_bishop.png';

      case 'black': return 'lib/assets/black_bishop.png';

      default: return ''; 
    } 
  }
}