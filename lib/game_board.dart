import 'package:chess/components/piece.dart';
import 'package:chess/components/square.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';

import 'components/dead_piece.dart';
import 'helper/helper_methods.dart';
class GameBoard extends StatefulWidget{


  const GameBoard({super.key});
  @override
  State <GameBoard> createState()=> _GameBoardState();

  }
  class _GameBoardState extends State<GameBoard>{
    late List<List<ChessPiece?>>board;
    ChessPiece? selectedPiece ;
    int selectedRow=-1;
    int selectedCol=-1;
    List<List<int>>validmoves=[];
  List<ChessPiece> whitePiecestaken=[];
  List<ChessPiece>blackPiecestaken=[];
  bool isWhiteTurn = true;
  List<int> whiteKingPosition=[7,4];
  List<int>blackKingPosition=[0,4];

  bool checkStatus= false;

  @override
    void initState(){
      // this is because to imtialize the board
      super.initState();
      _intializeBoard();
    }
    void movePiece(int newRow , int newCol){
     if(board[newRow][newCol]!=null){
       var capturedPiece=board[newRow][newCol];
       if(capturedPiece!.isWhite){
         whitePiecestaken.add(capturedPiece);
       }
       else{
         blackPiecestaken.add(capturedPiece);
       }
     }
     if(selectedPiece==ChessPieceType.king){
  if(selectedPiece!.isWhite){
    whiteKingPosition=[newRow, newCol];

  }else{
    blackKingPosition= [newRow,newCol];
  }
     }
      board[newRow][newCol]=selectedPiece;
      board[selectedRow][selectedCol]= null;
      if(IsKingInCheck(!isWhiteTurn)){
    checkStatus = true;
      }
      else{
        checkStatus= false;
      }
      setState(() {
        selectedPiece= null;
        selectedCol=-1;
        selectedRow=-1;
        validmoves=[];
      });
      if(isCheckmate(!isWhiteTurn)){
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: const Text("CHECKMATE"),
       actions: [
         TextButton(onPressed: resetgame, child: const Text(" Play Again"))
       ],
        ),
        );
      }
      isWhiteTurn=!isWhiteTurn;
    }
    bool IsKingInCheck(bool isWhiteKing){
      List<int>KingPostion= isWhiteKing? whiteKingPosition:blackKingPosition;
      for(int i=0;i<8;i++){
        for(int  j=0; j<8; j++ ){
          if(board[i][j]==null || board[i][j]!.isWhite == isWhiteKing)
          {
            continue;
          }
          List<List<int>> pieceValidMoves =  calculateRealValidMoves(i,j,board[i][j], false);
        if(pieceValidMoves.any((move)=>move[0]==KingPostion[0] && move[1]==KingPostion[1] )){
          return true;
        }
        }
      }
      return false;
    }
    void _intializeBoard(){
      List<List<ChessPiece?>> newBoard= List.generate(8, (index)=>List.generate(8, (index)=> null ));
  //  newBoard[3][3]= ChessPiece(type:ChessPieceType.king, isWhite: false, imagePath:'lib/images/Chess_bdt60.png');
      for(int i =0; i<8; i++){
      newBoard[1][i]= ChessPiece(type: ChessPieceType.pawn, isWhite: false , imagePath:'lib/images/Chess_pdt60.png');
    newBoard[6][i]= ChessPiece(type: ChessPieceType.pawn, isWhite: true, imagePath: 'lib/images/Chess_plt60.png');
    }
    newBoard[0][0]= ChessPiece(type:ChessPieceType.rook , isWhite: false, imagePath: 'lib/images/Chess_rdt60.png');
      newBoard[0][7]= ChessPiece(type:ChessPieceType.rook , isWhite: false, imagePath: 'lib/images/Chess_rdt60.png');
      newBoard[7][0]= ChessPiece(type:ChessPieceType.rook , isWhite: true, imagePath: 'lib/images/Chess_rlt60.png');
      newBoard[7][7]= ChessPiece(type:ChessPieceType.rook , isWhite: true, imagePath: 'lib/images/Chess_rlt60.png');
      //
      newBoard[0][1]= ChessPiece(type: ChessPieceType.knight, isWhite: false, imagePath: 'lib/images/Chess_ndt60.png');
      newBoard[0][6]= ChessPiece(type: ChessPieceType.knight, isWhite: false, imagePath: 'lib/images/Chess_ndt60.png');
      newBoard[7][1]= ChessPiece(type: ChessPieceType.knight, isWhite: true, imagePath: 'lib/images/Chess_nlt60.png');
      newBoard[7][6]= ChessPiece(type: ChessPieceType.knight, isWhite: true, imagePath: 'lib/images/Chess_nlt60.png');
      //
      newBoard[0][2]= ChessPiece(type: ChessPieceType.bishop, isWhite: false, imagePath: 'lib/images/Chess_bdt60.png');
      newBoard[0][5]= ChessPiece(type: ChessPieceType.bishop, isWhite: false, imagePath: 'lib/images/Chess_bdt60.png');
      newBoard[7][2]= ChessPiece(type: ChessPieceType.bishop, isWhite: true, imagePath: 'lib/images/Chess_blt60.png');
      newBoard[7][5]= ChessPiece(type: ChessPieceType.bishop, isWhite: true, imagePath: 'lib/images/Chess_blt60.png');
      //
      newBoard[0][3]= ChessPiece(type: ChessPieceType.queen, isWhite: false, imagePath: 'lib/images/Chess_qdt60.png');
      newBoard[7][4]= ChessPiece(type: ChessPieceType.queen, isWhite: true, imagePath: 'lib/images/Chess_qlt60.png');
      //
      newBoard[0][4]= ChessPiece(type: ChessPieceType.king, isWhite: false, imagePath:'lib/images/Chess_kdt60.png');
      newBoard[7][3]= ChessPiece(type: ChessPieceType.king, isWhite: true, imagePath:'lib/images/Chess_klt60.png');
      //
    board= newBoard;
    }
  // ChessPiece myPawn= ChessPiece(type: ChessPieceType.pawn, isWhite: false, imagePath: 'lib/images/Chess_bdt60.png');
  void pieceSelected(int row , int col){
      setState((){
      // if(board[row][col]!=null){
      //   selectedPiece= board[row][col];
      //   selectedRow= row;
      //   selectedCol=col;
      // }
        if(selectedPiece==null&& board[row][col]!=null){
          if(board[row][col]!.isWhite== isWhiteTurn){
          selectedPiece= board[row][col];
          selectedRow= row;
          selectedCol= col;
          }
        }
        else if(board[row][col]!=null && board[row][col]!.isWhite== selectedPiece!.isWhite){
          selectedPiece= board[row][col];
          selectedRow= row;
          selectedCol= col;
        }
else if(selectedPiece!=null&& validmoves.any((element)=> element[0]==row&& element[1]==col)){
      movePiece(row, col);
      }
      validmoves= calculateRealValidMoves(selectedRow, selectedCol, selectedPiece,true);
      }
      );
  }
  List<List<int>> calculateRealValidMoves(int row, int col , ChessPiece? piece,bool checkSimulator){
    List<List<int>> realValidMoves=[];
    List<List<int>> candidateMoves= CalculateRawValidMoves(row, col, piece);
    if (checkSimulator){
      for ( var move in candidateMoves){
        int endRow= move[0];
        int endCol= move[1];
        if(simulatedMoveIsSafe(piece!, row, col, endRow, endCol)){
      realValidMoves.add(move);
        }
      }
    }else{
      realValidMoves=candidateMoves;
    }
  return realValidMoves;
  }
  List<List<int>>CalculateRawValidMoves(int row, int col, ChessPiece? piece){
      List<List<int>> candidateMoves=[];
      //check
      int direction = piece!.isWhite?-1:1;
   //    if(piece==null){
   // return[];
   //    }

      switch(piece.type){
        case ChessPieceType.pawn:
          // this is the case where the pawn moves forward if not blocked
          if(isInBoard(row+direction, col) && board[row+direction][ col]== null){
            candidateMoves.add([row+direction,col]);
      }
          // this is the case where the pawn moves from the start
            if((row==1 && !piece.isWhite)|| (row==6 && piece.isWhite)){
              if(isInBoard(row+2*direction, col)&& board[row+2*direction][col]==null&& board[row+direction][col]==null ){
              candidateMoves.add([row+2 * direction, col]);
              }
            }
            // this is the case where the pawn kills diagonally
      if (isInBoard(row+ direction,col-1)&& board[row+direction][col-1]!=null&& board [row+direction][col-1]!.isWhite!=piece.isWhite){
        candidateMoves.add([row+ direction , col-1]);
      }
          if (isInBoard(row+ direction,col+1)&& board[row+direction][col+1]!=null&& board [row+direction][col+1]!.isWhite!=piece.isWhite){
            candidateMoves.add([row+ direction , col+1]);
          }
          break;
        case ChessPieceType.rook:
          var directions= [[-1,0], [1,0], [0,-1], [0,1]];
          for(var  direction in directions){
            var i =1;
            while(true){
              var newRow= row+i* direction[0];
              var newCol= col + i * direction[1];
              if(!isInBoard(newRow, newCol)){
                break;
              }
              if(board[newRow][newCol]!= null){
                // here we check that if we that when we  are moving if we can kill some piece
                if(board[newRow][newCol]!.isWhite!=piece.isWhite){
                  candidateMoves.add([newRow, newCol]);
                }
                break;
              }
            candidateMoves.add([newRow, newCol]);
              i++;
            }

          }
          break;

          // TODO: Handle this case.
        case ChessPieceType.knight:
          var knightMoves=[[-2,-1], [-2,1],[-1,-2],[-1,2],[1,-2], [1,2],[2,-1], [2,1]];
          for (var move in knightMoves){
            var newRow = row+ move[0];
            // doubtttt
            var newCol= col+move[1];
            if(!isInBoard(newRow, newCol)){
              continue;
            }
            if(board[newRow][newCol]!=null){
              if(board[newRow][newCol]!.isWhite!= piece.isWhite){
                candidateMoves.add([newRow, newCol]);
              }
              continue;
            }
            candidateMoves.add([newRow, newCol]);
          }
          break;
          // TODO: Handle this case.
        case ChessPieceType.bishop:
          var directions=[
            [-1,-1],[-1,1],[1,-1],[1,1]
          ];
          for( var direction in directions){
            var i=1;
            while(true){
              var newRow= row+i* direction[0];
              var newCol = col+i*direction[1];
              if(!isInBoard(newRow, newCol)){
                break;
              }
              if(board[newRow][newCol]!= null){
                if(board[newRow][newCol]!.isWhite!=piece.isWhite){
                  candidateMoves.add([newRow, newCol]);
                }
                // check this one
                break;
              }
              candidateMoves.add([newRow, newCol]);
              i++;

              }

      }

          break;
          // TODO: Handle this case.
        case ChessPieceType.queen:
          var directions =[[-1,0],[1,0],[0,-1],[0,1],[-1,-1], [-1,1],[1,-1],[1,1]];
          for( var direction in directions){
            var i= 1;
            while(true){
              var newRow= row+i * direction[0];
              var newCol= col+i * direction[1];
              if(!isInBoard(newRow, newCol)){
                break;
              }
              if(board[newRow][newCol]!=null){
                if(board[newRow][newCol]!.isWhite!=piece.isWhite){
                  candidateMoves.add([newRow,newCol]);
                }
                break;
              }
            candidateMoves.add([newRow, newCol]);
              i++;
            }
            
          }
          // might need to check for all breaks
          break;
      // TODO: Handle this case.
        case ChessPieceType.king:
          var directions =[[-1,0],[1,0],[0,-1],[0,1],[-1,-1], [-1,1],[1,-1],[1,1]];
          //var i=1;
          for(var direction in directions){
            var newRow= row+direction[0];
            var newCol= col+direction[1];
            if(!isInBoard(newRow, newCol)){
              continue;
            }
            if(board[newRow][newCol]!=null){
              if (board[newRow][newCol]!.isWhite!=piece.isWhite){
                candidateMoves.add([newRow,newCol]);
              }
              continue;
            }
            candidateMoves.add([newRow,newCol]);
          }
          break;
        default:
          // TODO: Handle this case.


      }
      return candidateMoves;
  }
  bool simulatedMoveIsSafe(ChessPiece piece, int startRow, int startCol, int endRow, int endCol ){
ChessPiece? originalDestination= board [endRow][endCol];
List<int>? originalKingPosition;
if(piece.type== ChessPieceType.king){
  originalKingPosition= piece.isWhite? whiteKingPosition: blackKingPosition;
if(piece.isWhite){
  whiteKingPosition=[endRow,endCol];
}else{
  blackKingPosition=[endRow,endCol];
}

}

board[endRow][endCol]= piece;
board[startRow][startCol]=null;
bool KingInCheck=IsKingInCheck(piece.isWhite);
board [startRow][startCol]= piece;
board[ endRow][endCol]=originalDestination;
if(piece.type== ChessPieceType.king) {
  if (piece!.isWhite) {
    whiteKingPosition = originalKingPosition!;
  } else {
    blackKingPosition = originalKingPosition!;
  }
}
return !KingInCheck;
  }
  bool isCheckmate(bool isWhiteKing){
    if(!IsKingInCheck(isWhiteKing))
  return false;
    for(int i =1 ; i<8; i++){
      for(int j=0;j<8;j++ ){
        if(board[i][j]== null || board[i][j]!.isWhite !=isWhiteKing){
          continue;
        }
        List<List<int>> piecevalidmoves= calculateRealValidMoves(i,j,board[i][j], true);
      if(piecevalidmoves.isNotEmpty){
        return false;
      }

      }
    }


    return true;




  }
  void resetgame(){
    Navigator.pop(context);
    _intializeBoard();
    checkStatus = false;
    whitePiecestaken.clear();
    blackPiecestaken.clear();
    whiteKingPosition=[7,4];
    blackKingPosition=[0,4];
    isWhiteTurn = true;
    setState(() {

    });
  }

    @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
              child:
          GridView.builder(physics: const NeverScrollableScrollPhysics(),itemCount: whitePiecestaken.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:8 ), itemBuilder: (context, index)=> DeadPiece(imagePath:  whitePiecestaken[index].imagePath, isWhite: true,       ))
          ),
     Text(
       checkStatus?"CHECK" :  ""
     ),
     Expanded(
       flex: 3,
       child:
      GridView.builder( itemCount: 8*8,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount : 8), itemBuilder: (context, index ){
        // int x = index~/8;
        // int y = index %8;
        // bool isWhite = (x+y)%2==0;
        int row = index~/8;
        int col = index%8;
        bool isSelected= selectedRow== row && selectedCol==col;
        bool isValidMove= false;
        for(var position in validmoves){
          if(position[0]== row && position[1]==col){
            isValidMove= true;
          }
        }
        return Square (isWhite :isWhite(index),
        piece: board[row][col],
          isSelected: isSelected,
          isValidMove: isValidMove,

          onTap: ()=>pieceSelected(row, col),
        );
          }
          ),
     ),
          Expanded(child:
          GridView.builder(physics : NeverScrollableScrollPhysics(),itemCount: blackPiecestaken.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:8 ), itemBuilder: (context, index)=> DeadPiece(imagePath:  blackPiecestaken[index].imagePath, isWhite: false,       ))
          ),

        ]));
  }
  }
