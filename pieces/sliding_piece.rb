require_relative '../pieces'
class SlidingPiece < Piece

  def move_piece?(dest)
    super && path_clear?(dest)
  end

  def path_clear?(dest)
    drow = position[0] <=> dest[0] #test this to make sure spaceship is in the right place
    dcol = position[1] <=> dest[1]
    reached_dest = ((position[0] + drow) > dest[0]) && ((position[1] + dcol) > dest[1])
    current_pos = position
    clear = true
    current_pos = [position[0] + drow, position[1] + dcol]
    until reached_dest
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