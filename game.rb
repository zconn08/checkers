#refactor play_turn
#require move to be a valid move
# delete a piece on a jump

require_relative 'player.rb'
require_relative 'board.rb'

class Game
  attr_accessor :current_player
  attr_reader :board

  def initialize(player_one, player_two)
    @player_one, @player_two = player_one, player_two
    @current_player = player_one
    player_one.color, player_two.color = "White", "Black"
    @board = Board.new
  end

  def run

  end

  def play_turn
    system('clear')


    loop do
      move_inputs = []
      while move_inputs.length < 2
        render_with_instructions
        @board.debugging_output
        cursor_move = current_player.get_cursor_movement

        board.move_cursor(cursor_move)

        move_inputs << board.cursor if cursor_move == "\r"
        render_with_instructions
      end
      move_a_piece(move_inputs)
      render_with_instructions
    end
  end

  def render_with_instructions
    system('clear')
    board.render
    puts "Please make a move #{@current_player.name}. Your color is #{@current_player.color}"
    puts "______________________________________________________"
    puts "Instructions:"
    puts "Please use WASD to navigate and Enter to select."
    puts "Cancel a move by selecting the same piece twice, push Q to quit"
  end

  def move_a_piece(move_inputs)
    start_pos, end_pos = move_inputs
    @board[start_pos].perform_slide(end_pos)
    @board[start_pos].perform_jump(end_pos)
  end

end

new_game = Game.new(Player.new("ZC"),Player.new("Opponent"))
new_game.play_turn
