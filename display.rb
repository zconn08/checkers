module Display

  MOVES = {
    "a" => [0, -1],
    "s" => [1, 0],
    "d" => [0, 1],
    "w" => [-1, 0]
  }

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
