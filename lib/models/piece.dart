import 'package:chess_game/models/position.dart';

abstract interface class Piece {
  String get color;
  String get assetPath;
  Position get position;

  List<Position> possiblePositions();
}