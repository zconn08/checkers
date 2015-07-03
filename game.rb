#refactor play_turn
#require move to be a valid move
# fix highlighting
# fix logos for kings
#dup, check if all moves are valid
#get turns working

require_relative 'player.rb'
require_relative 'board.rb'

class Game
  attr_accessor :current_player
  attr_reader :board

  def initialize(player_one, player_two)
    @player_one, @player_two = player_one, player_two
    @current_player = @player_one
    player_one.color, player_two.color = "White", "Black"
    @board = Board.new
  end

  def run
    until game_over?
      play_turn
      change_turn
    end
    puts "Game over"
  end

  def play_turn
    system('clear')

    ending_inputs, intermediate_steps = get_valid_inputs

    move_sequence = build_move_sequence(ending_inputs, intermediate_steps)
    start_pos = ending_inputs[0]
    @board[start_pos].perform_moves(move_sequence)
    render_with_instructions
  end

  def render_with_instructions
    system('clear')
    board.render
    puts "Please make a move #{@current_player.name}. Your color is #{@current_player.color}"
    puts "______________________________________________________"
    puts "Instructions:"
    puts "Please use WASD to navigate and Enter to select."
    puts "Do intermediate jumps by pressing 'j' on each intermediate location"
    puts "Cancel a move by selecting the same piece twice, push Q to quit"
  end

  def build_move_sequence(ending_inputs, intermediate_steps)
    move_sequence = []

    start_pos, end_pos = ending_inputs
    return [[start_pos, end_pos]] if intermediate_steps.length == 0

    move_sequence << [start_pos, intermediate_steps.first]
    intermediate_steps.each_with_index do |intermediate_step,idx|
      if (idx+1) < intermediate_steps.length
        move_sequence << [intermediate_step, intermediate_steps[idx+1]]
      end
    end
    move_sequence << [intermediate_steps.last, end_pos]
  end

  def game_over?
    board.black_win? || board.white_win?
  end

  def change_turn
    @current_player = (@current_player == @player_one) ? @player_two : @player_one
  end

  def get_valid_inputs
    ending_inputs = []
    intermediate_steps = []

    while ending_inputs.length < 2
      render_with_instructions

      #debugging studd
      @board.debugging_output
      p intermediate_steps

      cursor_move = current_player.get_cursor_movement
      board.move_cursor(cursor_move)

      ending_inputs << board.cursor if cursor_move == "\r"
      intermediate_steps << board.cursor if cursor_move == "j"
      render_with_instructions
    end
    get_valid_inputs if ending_inputs.uniq.length == 1
    [ending_inputs,intermediate_steps]
  end

end

new_game = Game.new(Player.new("ZC"),Player.new("Opponent"))
new_game.run
