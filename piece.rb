require 'colorize'

class Piece

  attr_reader :color, :kinged, :symbol

  def initialize(color, pos, board)
    @color = color
    @board = board
    @kinged = false
    @symbol = set_symbol
  end

  def set_symbol
    if color == "red" && kinged == false
      "\u26AA"
    elsif color == "black" && kinged == false
      "\u26AB"
    elsif color == "red" && kinged == true
      "\u26C1"
    else
      "\u26C3"
    end
  end


end

class EmptySpace
  attr_reader :symbol

  def initialize(pos)
    @pos = pos
    @symbol = " "
  end
end
