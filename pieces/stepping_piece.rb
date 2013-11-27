require_relative '../pieces'
class SteppingPiece < Piece
  attr_accessor :deltas
  def moves
    self.deltas.map do |delt|
      [position.first + delt.first, position.last + delt.last]
    end.select {|x,y| on_board?([x,y]) }
  end
end