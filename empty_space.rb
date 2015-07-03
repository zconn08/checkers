class EmptySpace
  attr_accessor :pos, :color
  attr_reader :symbol

  def initialize(pos)
    @pos = pos
    @symbol = " "
    @color = nil
  end

  def perform_slide(end_pos)
  end
  def perform_jump(end_pos)
  end
  def valid_moves
    []
  end
  def kinged?
    ""
  end
  def perform_moves!(move_sequence)
  end
  def perform_moves(move_sequence)
  end

  def dupe(board)
    self.class.new(pos.dup)
  end

end
