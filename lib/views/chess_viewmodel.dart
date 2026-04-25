import 'package:chess_game/models/pieces/king.dart';
import 'package:chess_game/models/pieces/piece.dart';
import 'package:chess_game/models/position.dart';
import 'package:chess_game/services/game_engine.dart';
import 'package:stacked/stacked.dart';


class ChessViewModel extends BaseViewModel {
  GameEngine currentEngine = GameEngine();

  void onPieceTapped(Piece piece) {
    if (piece.color != currentEngine.playerTurn) return;

    currentEngine.selectedPiece = piece;
    currentEngine.legalPositions = currentEngine.getLegalPositions(currentEngine.board, piece);

    rebuildUi();
  }

  void onPositionTapped(Position position) {
    bool didCasting = false;

    for (Position castingPosition in currentEngine.castingPositions) {
      if (castingPosition.x == position.x && castingPosition.y == position.y) {
        if (currentEngine.selectedPiece is King) currentEngine.doCasting(position);

        didCasting = true;
      } 
    }

    if (!didCasting) currentEngine.movePiece(currentEngine.board, position, currentEngine.selectedPiece!);


    currentEngine.playMoveSound();

    if (currentEngine.playerTurn == 'white') {
      currentEngine.playerTurn = 'black';
    } else {
      currentEngine.playerTurn = 'white';
    }

    rebuildUi();
  }
}