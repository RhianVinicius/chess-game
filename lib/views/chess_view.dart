import 'package:chess_game/views/chess_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChessView extends StackedView<ChessViewModel> {
  const ChessView({super.key});

  @override
  Widget builder(BuildContext context, ChessViewModel viewModel, Widget? child) {

    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double boardSize = constraints.maxWidth;
              double squareSize = boardSize / 8;

              return Stack(
                children: [
                  Image.asset('lib/assets/board.png', fit:BoxFit.contain),

                  ...viewModel.board.boardPieces.map((piece) {
                    return Positioned(
                      left: squareSize * piece.position.x,
                      bottom: squareSize * piece.position.y,
                      width: squareSize,
                      height: squareSize,
                      child: GestureDetector(
                        onTap: () {
                          // To-do: Show legal moves to do  
                        },
                        child: Image.asset(piece.assetPath, fit: BoxFit.contain),
                      )
                    );
                  }),

                  ...viewModel.board.selectedPositions.map((position) {
                    return Positioned(
                      left: squareSize * position.x,
                      bottom: squareSize * position.y,
                      width: squareSize,
                      height: squareSize,
                      child: GestureDetector(
                        onTap: () {
                          // To-do: Implemet movement/take
                        },
                        child: Opacity(
                          opacity: 0.25,
                          child: Image.asset('lib/assets/select_dot.png'),
                        ),
                      )
                    );
                  })
                ],
              );
            } 
          )
        ),
      )
    );
  }

  @override
  ChessViewModel viewModelBuilder(BuildContext context) => ChessViewModel();
}
