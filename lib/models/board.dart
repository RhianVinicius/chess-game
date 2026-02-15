import 'package:chess_game/models/piece.dart';
import 'package:chess_game/models/pieces/bishop.dart';
import 'package:chess_game/models/pieces/king.dart';
import 'package:chess_game/models/pieces/knight.dart';
import 'package:chess_game/models/pieces/pawn.dart';
import 'package:chess_game/models/pieces/queen.dart';
import 'package:chess_game/models/pieces/rook.dart';
import 'package:chess_game/models/position.dart';

class Board {
  late List<Piece> boardPosition;
  String playerTurn = 'white';


  Board() {
    boardPosition = _buildBorad();
  }


  bool pieceInPosition(Position position) {
    for (Piece piece in boardPosition) {
      if (position.positionName == piece.position.positionName) return true;
    }
    return false;
  }


  List<Piece> _buildBorad() {
    List<Piece> initialPosition = [];

    _placeWhitePieces(initialPosition);
    _placeBlackPieces(initialPosition);

    return initialPosition;
  }

  void _placeWhitePieces(List<Piece> boardPosition) {
    boardPosition.add(King('white', Position(3, 0))); 
    boardPosition.add(Queen('white', Position(4, 0)));
    boardPosition.add(Bishop('white', Position(2, 0)));
    boardPosition.add(Bishop('white', Position(5, 0)));
    boardPosition.add(Knight('white', Position(1, 0)));
    boardPosition.add(Knight('white', Position(6, 0)));
    boardPosition.add(Rook('white', Position(0, 0)));
    boardPosition.add(Rook('white', Position(7, 0)));

    boardPosition.add(Pawn('white', Position(0, 1)));
    boardPosition.add(Pawn('white', Position(1, 1)));
    boardPosition.add(Pawn('white', Position(2, 1)));
    boardPosition.add(Pawn('white', Position(3, 1)));
    boardPosition.add(Pawn('white', Position(4, 1)));
    boardPosition.add(Pawn('white', Position(5, 1)));
    boardPosition.add(Pawn('white', Position(6, 1)));
    boardPosition.add(Pawn('white', Position(7, 1)));
  }

  void _placeBlackPieces(List<Piece> boardPosition) {
    boardPosition.add(King('black', Position(3, 7))); 
    boardPosition.add(Queen('black', Position(4, 7)));
    boardPosition.add(Bishop('black', Position(2, 7)));
    boardPosition.add(Bishop('black', Position(5, 7)));
    boardPosition.add(Knight('black', Position(1, 7)));
    boardPosition.add(Knight('black', Position(6, 7)));
    boardPosition.add(Rook('black', Position(0, 7)));
    boardPosition.add(Rook('black', Position(7, 7)));

    boardPosition.add(Pawn('black', Position(0, 6)));
    boardPosition.add(Pawn('black', Position(1, 6)));
    boardPosition.add(Pawn('black', Position(2, 6)));
    boardPosition.add(Pawn('black', Position(3, 6)));
    boardPosition.add(Pawn('black', Position(4, 6)));
    boardPosition.add(Pawn('black', Position(5, 6)));
    boardPosition.add(Pawn('black', Position(6, 6)));
    boardPosition.add(Pawn('black', Position(7, 6)));
  }
}