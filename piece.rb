require 'colorize'
require 'byebug'

class Piece

  attr_accessor :pos, :symbol, :kinged
  attr_reader :color, :board

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @kinged = false
    @symbol = set_initial_symbol
  end

  def set_initial_symbol
    color == "White" ? "\u26AA" : "\u26AB"
  end

  def make_king
    @kinged = true
  end

  def kinged?
    @kinged
  end

  def possible_slides
    if color == "White" && kinged == false
      [[1,1],[1,-1]]
    elsif color == "Black" && kinged == false
      [[-1,-1],[-1,1]]
    else
      [[1,1],[1,-1],[-1,-1],[-1,1]]
    end
  end

  def valid_moves
    valid_slides + valid_jumps
  end

  def valid_slides
    moves = []
    x, y = pos
    possible_slides.each do |dx, dy|
      slide_to_position = [x + dx, y + dy]
      moves << slide_to_position if legal_slide?(slide_to_position)
    end
    moves
  end

  def valid_jumps
    moves = []
    x, y = pos
    possible_slides.each do |dx, dy|
      jump_over_position = [x + dx, y + dy]
      jump_to_positon = [x + (dx * 2), y + (dy * 2)]
      if legal_jump?(jump_to_positon, jump_over_position)
        moves << jump_to_positon
      end
    end
    moves
  end

  def is_a_slide?(start_pos,end_pos)
    dx = end_pos[0] - start_pos[0]
    dy = end_pos[1] - start_pos[1]

    possible_slides.include?([dx,dy])
  end

  def is_a_jump?(start_pos,end_pos)
    dx = end_pos[0] - start_pos[0]
    dy = end_pos[1] - start_pos[1]

    possible_slides.include?([(dx/2),(dy/2)])
  end

  def is_a_jump?

  end

  def perform_slide(end_pos)
    if valid_slides.include?(end_pos)
      switch_pieces(end_pos)
      maybe_promote
    end
  end

  def perform_jump(end_pos)
    if valid_jumps.include?(end_pos)
      mid_piece_pos = [(pos[0] + end_pos[0])/2, (pos[1] + end_pos[1])/2 ]
      board[mid_piece_pos] = EmptySpace.new(mid_piece_pos)
      switch_pieces(end_pos)
      maybe_promote
    end
  end

  def other_color(color)
    color == "Black" ? "White" : "Black"
  end

  def legal_jump?(jump_to_positon, jump_over_position)
    board.on_board?(jump_to_positon) &&
    board[jump_to_positon].is_a?(EmptySpace) &&
    board[jump_over_position].is_a?(Piece) &&
    board[jump_over_position].color == other_color(color)
  end

  def legal_slide?(slide_to_position)
    board.on_board?(slide_to_position) &&
    board[slide_to_position].is_a?(EmptySpace)
  end

  def switch_pieces(end_pos)
    board[pos], board[end_pos] = board[end_pos], board[pos]
    board[pos].pos, board[end_pos].pos = board[end_pos].pos, board[pos].pos
  end

  def maybe_promote
    if pos[0] == 7 && color == "White"
      make_king
      @symbol = "\u2616"
    elsif pos[0] == 0 && color == "Black"
      make_king
      @symbol = "\u2617"
    end
  end

  def perform_moves!(move_sequence)
    move_sequence.each_with_index do |sequence, idx|
      start_pos,end_pos = sequence
      @board[start_pos].perform_slide(end_pos) if idx == 0
      @board[start_pos].perform_jump(end_pos)
    end
  end

  def valid_moves?(move_sequence)
    duped_board = board.deep_dup
    move_sequence.each_with_index do |sequence, idx|
      start_pos,end_pos = sequence
      mid_piece_pos = [(start_pos[0] + end_pos[0])/2, (start_pos[1] + end_pos[1])/2 ]
      if (idx == 0) && duped_board[start_pos].is_a_slide?(start_pos, end_pos)
        unless duped_board[start_pos].legal_slide?(end_pos)
          return false
        end
        duped_board[start_pos].perform_slide(end_pos)
      elsif !(duped_board[start_pos].legal_jump?(end_pos, mid_piece_pos))
        p mid_piece_pos
        p "ILLEGAL JUMP"
        return false
      else
        "LEGAL JUMP"
        duped_board[start_pos].perform_jump(end_pos)
      end
    end
    true
  end

  def perform_moves(move_sequence)
    perform_moves!(move_sequence) if valid_moves?(move_sequence)
  end

  def dupe(board)
    self.class.new(color, pos.dup, board)
  end

end
