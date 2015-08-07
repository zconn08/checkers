module Display

  MOVES = {
    "a" => [0, -1],
    "s" => [1, 0],
    "d" => [0, 1],
    "w" => [-1, 0]
  }

  def debugging_output
    puts "Cursor: #{cursor}"
    puts "Position: #{self[cursor].pos}"
    puts "Color: #{self[cursor].color}"
    puts "Valid Moves: #{self[cursor].valid_moves}"
    puts "Kinged?: #{self[cursor].kinged?}"

  end

  def move_cursor(player_input)
    exit if player_input == "q"
    direction = MOVES[player_input]
    unless direction.nil?
      x, y = cursor
      dx, dy = direction
      potential_x, potential_y = cursor[0] + dx, cursor[1] + dy
      @cursor = [potential_x, potential_y] if on_board?([potential_x,potential_y])
    end
  end
end
