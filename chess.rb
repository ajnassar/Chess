# coding: utf-8
require 'colorize'
class Game
end

class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    fill_board
  end

  def fill_board
    grid.count.times do |row|
      color = (row == 0 || row == 1) ? :black : :white
      grid.count.times do |col|

        grid[row][col] =
        if row == 1 || row == 6
          Pawn.new(self,[row, col], color)
        elsif row == 0
          if col == 0 || col == 7
            Rook.new(self,[row, col] , color)
          elsif col == 1 || col == 6
            Knight.new(self,[row, col], color)
          elsif col == 2 || col == 5
            Bishop.new(self,[row, col], color)
          elsif col == 3
             Queen.new(self,[row, col], color)
          elsif col == 4
            King.new(self,[row, col], color)
          end
        elsif row == 7
          if col == 0 || col == 7
            Rook.new(self,[row, col] , color)
          elsif col == 1 || col == 6
            Knight.new(self,[row, col], color)
          elsif col == 2 || col == 5
            Bishop.new(self,[row, col], color)
          elsif col == 3
            King.new(self,[row, col], color)
          elsif col == 4
            Queen.new(self,[row, col], color)
          end
        else
            "   "
        end
      end
    end
  end

  def to_s
    nil
  end

  def [](pos)
    x,y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    x,y = pos
    @grid[x][y] = piece
  end

  def render
    temp_board = ""
    grid.count.times do |row|
      temp_board += "\n"
      grid.count.times do |col|
        background = (row + col).even? ? :on_white : :on_black
        temp_board += grid[row][col].to_s.send(background)
      end
    end
    puts temp_board
  end
end

# coding: utf-8
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

  def moves
    raise NotImplemented
  end

  def on_board?(pos)
    pos.all? {|coord| coord.between?(0,7) }
  end
end

class SlidingPiece < Piece
  # def deltas
  #   x, y = position
  #   delts = []
  #   if move_dirs[:card_dir]
  #     delts += [[1,0],[0,-1],[-1,0],[0,1]]
  #   end
  #   if move_dirs[:diag_dir]
  #     delts += [[1,1],[1,-1],[-1,-1],[-1,1]]
  #   end
  #   delts
  # end

  def moves
    all_spots = []
    delts = self.deltas
    (0..7).each do |m|
      delts.each do |d|
        all_spots << d.map { |delt| delt * m }
      end
    end
    all_spots = all_spots.map do |x, y|
      [position[0] + x, position[1] + y]
    end.select {|pos| pos.all? {|el| el.between?(0,7)}}
    uniq_spots = []
    all_spots.each do |a_s|
      uniq_spots << a_s unless uniq_spots.include?(a_s)
    end
    uniq_spots
  end
end

class Rook < SlidingPiece
  # def deltas
  def deltas
    CARDINAL_DELTAS
  end
end

class Queen < Rook
  def deltas
    CARDINAL_DELTAS + DIAGONAL_DELTAS
  end
end

class Bishop < SlidingPiece
  def deltas
    DIAGONAL_DELTAS
  end
end

class SteppingPiece < Piece
  attr_accessor :deltas
  def moves
    self.deltas.map do |delt|
      [position.first + delt.first, position.last + delt.last]
    end.select {|x,y| on_board?([x,y]) }
  end
end

class Knight < SteppingPiece
  DELTAS = [[-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]]

  def deltas
    DELTAS
    # [[-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]]
  end
end

class King < SteppingPiece
  # DELTAS =
  def deltas
    CARDINAL_DELTAS + DIAGONAL_DELTAS
  end
end

class Pawn < Piece
  #if starting position
  def deltas
    delts = []
    if color == :black
      delts += [[0, 1],[0, 2]]
    elsif color == :white
      delts += [[0, -1],[0, -2]]
    end
    delts
  end

  def moves
    self.deltas.map do |delt|
      [position.first + delt.first, position.last + delt.last]
    end.select {|x,y| on_board?([x,y]) }
  end

  def attack?
    [[-1, 1],[1, -1],[-1, -1],[1, 1]]
  end
end





