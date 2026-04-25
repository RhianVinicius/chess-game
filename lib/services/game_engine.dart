import 'package:audioplayers/audioplayers.dart';
import 'package:chess_game/models/board.dart';
import 'package:chess_game/models/pieces/piece.dart';
import 'package:chess_game/models/pieces/bishop.dart';
import 'package:chess_game/models/pieces/king.dart';
import 'package:chess_game/models/pieces/knight.dart';
import 'package:chess_game/models/pieces/pawn.dart';
import 'package:chess_game/models/pieces/queen.dart';
import 'package:chess_game/models/pieces/rook.dart';
import 'package:chess_game/models/position.dart';
import 'package:flutter/services.dart';


class GameEngine {
  static const List<List<int>> diagonalDirections = [[1, 1], [1, -1], [-1, -1], [-1, 1]];
  static const List<List<int>> straightDirections = [[0, 1], [1, 0], [0, -1], [-1, 0]];
  static const List<List<int>> multiDirections = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]];
  static const List<List<int>> knightPositions = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]];
  static const List<List<int>> castleDirections = [[1, 0], [-1, 0]];
  static const List<List<int>> pawnMovePositions = [[0, 1], [0, 2]];
  static const List<List<int>> pawnAttackPositions = [[1, 1], [-1, 1]];

  final AudioPlayer soundPlayer = AudioPlayer();
  BytesSource? moveSound;

  Board board = Board();
  String playerTurn = 'white';
  List<Position> legalPositions = [];
  List<Position> castingPositions = [];
  Piece? selectedPiece; 
  bool isLookingCheck = false;


  GameEngine() {
    initSounds();
  }


  Future<void> initSounds() async {
    final data = await rootBundle.load('lib/assets/click.mp3');
    final bytes = data.buffer.asUint8List();

    moveSound = BytesSource(bytes);
  }

  Future<void> playMoveSound() async {
    if (moveSound == null) return;

    await soundPlayer.stop(); 
    await soundPlayer.play(moveSound!);
  }


  void movePiece(Board board, Position position, Piece piece) {
    board.destroyPiece(position);

    piece.setPosition(position);

    if (piece is Pawn || piece is King || piece is Rook) {
      piece.alreadyMoved = true;
    }

    if (isLookingCheck) return;

    legalPositions = [];
    castingPositions = [];
    selectedPiece = null;
  }

  bool _isPositionAttacekd(Board board, Position position) {
    bool isAttacked = false;
    List<Position> debugList;

    for (Piece piece in board.boardPieces) {
      if (piece.color == playerTurn) continue;

      debugList = getLegalPositions(board, piece); 
      for (Position attackedPosition in debugList) {
        if (attackedPosition.x == position.x && attackedPosition.y == position.y) {
          isAttacked = true;  
        }
      }
    }

    return isAttacked;
  }

  List<Position> getLegalPositions(Board board, Piece piece) {
    if (piece is King) return _getKingLegalPositions(board, piece);

    if (piece is Queen) return _getQueenLegalPositions(board, piece);

    if (piece is Bishop) return _getBishopLegalPositions(board, piece);

    if (piece is Knight) return _getKnightLegalPositions(board, piece);

    if (piece is Rook) return _getRookLegalPositions(board, piece);

    if (piece is Pawn) return _getPawnLegalPositions(board, piece);

   return[];
  }


  List<Position> _getKingLegalPositions(Board board, Piece piece) {
    List<Position> legalPositions = [];

    for (List<int> direction in multiDirections) {
      Position? newPosition;

      newPosition = piece.position.move(direction[0], direction[1]);

      if (newPosition == null) continue;

      

      if (board.pieceInPosition(newPosition)) {
        if (board.getPieceInPosition(newPosition)!.color != piece.color) {
          legalPositions.add(newPosition);
        }
        continue;
      }

      //if (!isLookingCheck) {
      //  if (_isKingInCheck(board, piece, newPosition)) continue;  
      //} 

      legalPositions.add(newPosition);
    }

    if (!isLookingCheck) {
      if (piece.color == playerTurn) legalPositions.addAll(_getCastingPositions(piece as King));
    }

    return legalPositions;  
  }

  List<Position> _getQueenLegalPositions(Board board, Piece piece) {
    List<Position> legalPositions = [];

    for (List<int> direction in multiDirections) {
      Position currentPosition = piece.position;
      Position? newPosition;

      while (true) {
        newPosition = currentPosition.move(direction[0], direction[1]);

        if (newPosition == null) break; 

        if (!isLookingCheck) {
          if (_isKingInCheck(board, piece, newPosition)) {
            currentPosition = newPosition;
            continue;  
          }
        } 

        if (board.pieceInPosition(newPosition)) {
          if (board.getPieceInPosition(newPosition)!.color != piece.color) {
            legalPositions.add(newPosition);
          }
          break;
        }

        legalPositions.add(newPosition);
        currentPosition = newPosition;
      }
    } 
    return legalPositions;
  }

  List<Position> _getBishopLegalPositions(Board board, Piece piece) {
    List<Position> legalPositions = [];

    for (List<int> direction in diagonalDirections) {
      Position currentPosition = piece.position;
      Position? newPosition;

      while (true) {
        newPosition = currentPosition.move(direction[0], direction[1]);

        if (newPosition == null) break;  

        if (!isLookingCheck) {
          if (_isKingInCheck(board, piece, newPosition)) {
            currentPosition = newPosition;
            continue;  
          }
        }

        if (board.pieceInPosition(newPosition)) {
          if (board.getPieceInPosition(newPosition)!.color != piece.color) {
            legalPositions.add(newPosition);
          }
          break;
        }

        legalPositions.add(newPosition);
        currentPosition = newPosition;
      }
    } 
    return legalPositions;
  }

  List<Position> _getKnightLegalPositions(Board board, Piece piece) {
    List<Position> legalPositions = [];

    for (List<int> knightPosition in knightPositions) {
      Position? newPosition;

      while (true) {
        newPosition = piece.position.move(knightPosition[0], knightPosition[1]);

        if (newPosition == null) break; 

        if (!isLookingCheck) {
          if (_isKingInCheck(board, piece, newPosition)) break;
        }  

        if (board.pieceInPosition(newPosition)) {
          if (board.getPieceInPosition(newPosition)!.color != piece.color) {
            legalPositions.add(newPosition);
          }
          break;
        }

        legalPositions.add(newPosition);
        break;
      }
    } 
    return legalPositions;
  }

  List<Position> _getRookLegalPositions(Board board, Piece piece) {
    List<Position> legalPositions = [];

    for (List<int> direction in straightDirections) {
      Position currentPosition = piece.position;
      Position? newPosition;

      while (true) {
        newPosition = currentPosition.move(direction[0], direction[1]);

        if (newPosition == null) break;  

        if (!isLookingCheck) {
          if (_isKingInCheck(board, piece, newPosition)) {
            currentPosition = newPosition;
            continue;  
          }
        } 

        if (board.pieceInPosition(newPosition)) {
          if (board.getPieceInPosition(newPosition)!.color != piece.color) {
            legalPositions.add(newPosition);
          }
          break;
        }

        legalPositions.add(newPosition);
        currentPosition = newPosition;
      }
    } 
    return legalPositions;
  }

  List<Position> _getPawnLegalPositions(Board board, Piece piece) {
    List<Position> legalPositions = [];

    for (List<int> move in pawnMovePositions) {
      Position? newPosition;

      if (piece.color == 'white') newPosition = piece.position.move(move[0], move[1]);
      if (piece.color == 'black') newPosition = piece.position.move(move[0], move[1]*-1);

      if (newPosition == null) break;

      if (!isLookingCheck) {
        if (_isKingInCheck(board, piece, newPosition)) continue;
      } 

      if (board.pieceInPosition(newPosition)) break;


      legalPositions.add(newPosition);

      if ((piece as Pawn).alreadyMoved) break;
    }


    for (List<int> move in pawnAttackPositions) {
      Position? newPosition;

      if (piece.color == 'white') newPosition = piece.position.move(move[0], move[1]);
      if (piece.color == 'black') newPosition = piece.position.move(move[0], move[1]*-1);

      if (newPosition == null) continue;

      if (board.pieceInPosition(newPosition)) {
        if (board.getPieceInPosition(newPosition)!.color == piece.color) continue;

        legalPositions.add(newPosition);
      }
    }

  return legalPositions;
  }


  List<Position> _getCastingPositions(King king) {
    List<Position> legalPositions = [];

    isLookingCheck = true;

    if (_isPositionAttacekd(board, king.position) || king.alreadyMoved) return legalPositions;

    for (List<int> direction in castleDirections) {
      Position? currentPosition = king.position;

      while (true) {
        currentPosition = currentPosition?.move(direction[0], direction[1]);

        if (currentPosition == null) break;

        if (_isPositionAttacekd(board, currentPosition)) break;

        if (board.pieceInPosition(currentPosition)) {
          if (board.getPieceInPosition(currentPosition) is !Rook) {
            break;
          } else if ((board.getPieceInPosition(currentPosition) as Rook).alreadyMoved) {
            break;
          } else {
            castingPositions.add(king.position.move(direction[0]*2, direction[1])!);
          }

          legalPositions.add(king.position.move(direction[0]*2, direction[1])!);
        }
      }
    }

    isLookingCheck = false;

    return legalPositions;
  }


  bool _isKingInCheck(Board board, Piece piece, Position position) {
    bool isInCheck = false;
    Board boardCopy = board.generateCopy();

    isLookingCheck = true;


    movePiece(boardCopy, Position(position.x, position.y), boardCopy.getPieceInPosition(Position(piece.position.x, piece.position.y))!);   

    for (Piece boardPiece in boardCopy.boardPieces) {
      if (boardPiece.color != playerTurn) continue;

      if (boardPiece is King) {
        isInCheck = _isPositionAttacekd(boardCopy, boardPiece.position);
      } 
    }

    isLookingCheck = false;

    return isInCheck;
  }


  void doCasting(Position position) {
    int newRookDirection;
    Position rookPosition;

    if (position.x > (selectedPiece as King).position.x) {
      newRookDirection = -1;
      rookPosition = Position(7, selectedPiece!.position.y);
    } else {
      newRookDirection = 1;
      rookPosition = Position(0, selectedPiece!.position.y);
    }

    movePiece(board, position, selectedPiece!);

    movePiece(board, position.move(newRookDirection, 0)!, board.getPieceInPosition(rookPosition)!);
  }
}
