require_relative "sliding_piece"
class Rook < SlidingPiece
  # def deltas
  def deltas
    CARDINAL_DELTAS
  end
end