require 'colorize'
require_relative 'pieces.rb'


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

  def valid_destination?(color, dest)
    self.grid[dest[0]][dest[1]].is_a?(String) ||
    self.grid[dest[0]][dest[1]].color != color
  end

  def check_position(pos)
    grid[pos[0]][pos[1]]
  end

end