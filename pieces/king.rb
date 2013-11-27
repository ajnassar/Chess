require_relative "stepping_piece"
class King < SteppingPiece
  def deltas
    CARDINAL_DELTAS + DIAGONAL_DELTAS
  end
end