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
end
