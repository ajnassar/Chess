
require_relative '../pieces'
class SlidingPiece < Piece

  def move_piece?(row, col)
    super && path_clear?(row, col)
  end

  def path_clear?(row, col)
    drow = row <=> position[0] #test this to make sure spaceship is in the right place
    dcol = col <=> position[1]
    p [drow, dcol]
    reached_dest = ((position[0] + drow) == row) && ((position[1] + dcol) == col)
    current_pos = position
    clear = true
    p reached_dest
    current_pos = [position[0], position[1]]
    until current_pos == [row - drow, col - dcol]
      p current_pos
      clear = false if board.check_position(current_pos).is_a?(String)
      current_pos = [current_pos[0] + drow, current_pos[1] + dcol]
    end
    clear
  end

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