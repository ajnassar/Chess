require_relative "rook"
class Queen < Rook
  def deltas
    CARDINAL_DELTAS + DIAGONAL_DELTAS
  end
end