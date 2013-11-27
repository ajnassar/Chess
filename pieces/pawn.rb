
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
