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
      puts row
      color = (row == 0 || row == 1) ? :black : :white
      grid.count.times do |col|
        # grid[row][col] = cold + row % 2 == 0 ? "\u265B".encode('utf-8') #white
        # grid[row][col] = #black
        case grid[row][col]
        when row == 1
          case col
          when col.between?(0,7)
            Pawn.new(self,[row, col], color)
          end
        when row == 6
          case col
          when col.between?(0,7)
            Pawn.new(self,[row, col], color)
          end
        when row == 0 || row == 7
          case col
          when col == 0 || col == 7
            Rook.new(self,[row, col] , color)
          end
        when row == 0 || row == 7
          case col
          when col == 1 || col == 6
            Knight.new(self,[row, col], color)
          end
        when row == 0 || row == 7

          && (col == 2 || col == 5)
          grid[row][col] = Bishop.new(self,[row, col], color)
        when row == 7 && (col == 2 || col == 5)
          grid[row][col] = Bishop.new(self,[row, col], color)
        when row == 0 && col == 4
          grid[row][col] = King.new(self,[row, col], color)
        when row == 7 && col == 3
          grid[row][col] = King.new(self,[row, col], color)
        when row == 0 && col == 3
          grid[row][col] = Queen.new(self,[row, col], color)
        when row == 7 && col == 4
          grid[row][col] = Queen.new(self,[row, col], color)
        end
      end
    end
  end

  def [](pos)
    x,y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    x,y = pos
    @grid[x][y] = piece
  end
end

class Piece
  CARDINAL_DELTAS = [[1,0],[0,-1],[-1,0],[0,1]]
  DIAGONAL_DELTAS = [[1,1],[1,-1],[-1,-1],[-1,1]]

  PIECE_SYMBOLS = {
    :white => {
      "Pawn" => "\u2659".encode('utf-8'),
      "Rook" => "\u2656".encode('utf-8'),
      "Knight" => "\u2658".encode('utf-8'),
      "Bishop" => "\u2657".encode('utf-8'),
      "King" => "\u2654".encode('utf-8'),
      "Queen" => "\u2655".encode('utf-8')
    },
    :black => {
      "Pawn" => "\u265F".encode('utf-8'),
      "Rook" => "\u265C".encode('utf-8'),
      "Knight" => "\u265E".encode('utf-8'),
      "Bishop" => "\u265D".encode('utf-8'),
      "King" => "\u265A".encode('utf-8'),
      "Queen" => "\u265B".encode('utf-8')
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
  def deltas
    x, y = position
    delts = []
    if move_dirs[:card_dir]
      delts += [[1,0],[0,-1],[-1,0],[0,1]]
    end
    if move_dirs[:diag_dir]
      delts += [[1,1],[1,-1],[-1,-1],[-1,1]]
    end
    delts
  end

  def moves
    all_spots = []
    delts = self.deltas
    (0..7).each do |m|
      delts.each do |d|
        all_spots << d.map { |delt| delt * m }
      end
    end
    all_spots = all_spots.map { |x, y| [position[0] + x, position[1] + y]  }.select {|pos| pos.all? {|el| el.between?(0,7)}}
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





