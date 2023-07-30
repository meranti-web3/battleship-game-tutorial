// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// This is a Smart Contract for playing Tic Tac Toe against another player.
// For simplicity, Each Smart Contract is a new game.
contract TicTacToeContract {
    enum GameStatus{ INITIALIZED, INPROGRESS, ENDED }

    address public player1;
    address public player2;
    address public playerTurn;
    GameStatus gameStatus;
    uint8[9] public board;
    
    constructor() {
        player1 = msg.sender;
        gameStatus = GameStatus.INITIALIZED;
    }

    function join() external {
        require(gameStatus == GameStatus.INITIALIZED, "Game already in progress or ended.");
        require(msg.sender != player1, "Must find someone else to play with!");
        player2 = msg.sender;
        gameStatus = GameStatus.INPROGRESS;
        playerTurn = player1;
    }

    function play(uint8 cell) external {
        require(gameStatus == GameStatus.INPROGRESS, "Game must be in progress.");
        require(msg.sender == player1 || msg.sender == player2, "Not a player.");
        require(msg.sender == playerTurn, "Not your turn.");
        require(board[cell] == 0, "Cell already occupied.");

        uint8 playerId = msg.sender == player1 ? 1 : 2;

        board[cell] = playerId;

        if (isWinner(playerId)) {
            gameStatus = GameStatus.ENDED;
            return;
        }

        if (isDraw()) {
            gameStatus = GameStatus.ENDED;
            return;
        }

        playerTurn = (playerTurn == player1) ? player2 : player1;
    }

    function isWinner(uint8 playerId) public view returns (bool) {
        // spelling out all 8 possibilites (3 rows, 3 cols, 2 diagonals) so code is easier to understand
        // 3 rows
        if (board[0] == playerId && board[1] == playerId && board[2] == playerId) return true;
        if (board[3] == playerId && board[4] == playerId && board[5] == playerId) return true;
        if (board[6] == playerId && board[7] == playerId && board[8] == playerId) return true;
        
        // 3 cols
        if (board[0] == playerId && board[3] == playerId && board[6] == playerId) return true;
        if (board[1] == playerId && board[4] == playerId && board[7] == playerId) return true;
        if (board[2] == playerId && board[5] == playerId && board[8]== playerId) return true;

        // 2 diagonals
        if (board[0] == playerId && board[4] == playerId && board[8] == playerId) return true;
        if (board[2] == playerId && board[4] == playerId && board[6] == playerId) return true;

        return false;
    }

    function isDraw() public view returns (bool) {
        for (uint8 i = 0; i < 9; i++) {
            // assume game isn't a draw until all cells have been played
            if (board[i] == 0) {
                return false;
            }
        }
        return true;
    }

    function getBoard() external view returns (uint8[9] memory) {
        return board;
    }
}
