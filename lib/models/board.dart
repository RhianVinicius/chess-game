import 'package:chess_game/models/pieces/piece.dart';
import 'package:chess_game/models/pieces/bishop.dart';
import 'package:chess_game/models/pieces/king.dart';
import 'package:chess_game/models/pieces/knight.dart';
import 'package:chess_game/models/pieces/pawn.dart';
import 'package:chess_game/models/pieces/queen.dart';
import 'package:chess_game/models/pieces/rook.dart';
import 'package:chess_game/models/position.dart';

class Board {
  late List<Piece> boardPieces;

  Board({bool autoPlacePieces = true}) {
    boardPieces = _buildBorad(autoPlacePieces);
  }


  Board generateCopy() {
    Board newBoard = Board(autoPlacePieces: false);

    for (Piece piece in boardPieces) {
      Piece? newPiece;

      if (piece is King) newPiece = King(piece.color, Position(piece.position.x, piece.position.y));
      
      if (piece is Queen) newPiece = Queen(piece.color, Position(piece.position.x, piece.position.y));

      if (piece is Bishop)  newPiece = Bishop(piece.color, Position(piece.position.x, piece.position.y));

      if (piece is Rook) newPiece = Rook(piece.color, Position(piece.position.x, piece.position.y)); 

      if (piece is Knight) newPiece = Knight(piece.color, Position(piece.position.x, piece.position.y));

      if (piece is Pawn) newPiece = Pawn(piece.color, Position(piece.position.x, piece.position.y));


      newBoard.boardPieces.add(newPiece!);    
    }
    return newBoard;
  }


  bool pieceInPosition(Position position) {
    for (Piece piece in boardPieces) {
      if (position.positionName == piece.position.positionName) return true;
    }
    return false;
  }


  Piece? getPieceInPosition(Position position) {
    for (Piece piece in boardPieces) {
      if (position.positionName == piece.position.positionName) return piece;
    }
    return null;
  }


  void destroyPiece(Position position) {
    boardPieces.removeWhere((piece) => piece.position.x == position.x && piece.position.y == position.y);
  }


  List<Piece> _buildBorad(bool autoPlacePieces) {
    List<Piece> initialPosition = [];

    if (autoPlacePieces) {
      _placeWhitePieces(initialPosition);
      _placeBlackPieces(initialPosition);
    }

    return initialPosition;
  }

  void _placeWhitePieces(List<Piece> boardPosition) {
    Pawn peao;
    peao = Pawn('white', Position(1, 2));
    peao.alreadyMoved = true;

    boardPosition.add(King('white', Position(4, 0))); 
    boardPosition.add(Queen('white', Position(3, 0)));
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
    boardPosition.add(King('black', Position(4, 7))); 
    boardPosition.add(Queen('black', Position(3, 7)));
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