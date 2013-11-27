# coding: utf-8
require 'colorize'


class Piece
  CARDINAL_DELTAS = [[1,0],[0,-1],[-1,0],[0,1]]
  DIAGONAL_DELTAS = [[1,1],[1,-1],[-1,-1],[-1,1]]

  PIECE_SYMBOLS = {
    :white => {
      "Pawn" => " ♙ ".green,
      "Rook" => " ♖ ".green,
      "Knight" => " ♘ ".green,
      "Bishop" => " ♗ ".green,
      "King" => " ♔ ".green,
      "Queen" => " ♕ ".green
    },
    :black => {
      "Pawn" => " ♟ ".red,
      "Rook" => " ♜ ".red,
      "Knight" => " ♞ ".red,
      "Bishop" => " ♝ ".red,
      "King" => " ♚ ".red,
      "Queen" => " ♛ ".red
    }
  }

  attr_reader :board, :color, :symbol
  attr_accessor :position

  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
  end

  def to_s
    PIECE_SYMBOLS[color][self.class.name]
  end

  def move_piece(dest)
    if move_piece?(dest)

    end
  end

  def move_piece?(dest)
    self.valid_position?(dest) && board.valid_destination?(color, dest)
  end



  def valid_position?(dest)
    self.moves.include?(dest)
  end


  def moves
    raise NotImplemented
  end

  def on_board?(pos)
    pos.all? {|coord| coord.between?(0,7) }
  end
end

require_relative "pieces/rook"
require_relative "pieces/bishop"
require_relative "pieces/knight"
require_relative "pieces/queen"
require_relative "pieces/king"
require_relative "pieces/pawn"


