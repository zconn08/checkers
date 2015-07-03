require_relative 'display.rb'
require_relative 'piece.rb'
require_relative 'empty_space.rb'
require 'colorize'

class Board

  attr_accessor :grid, :cursor
  attr_reader :grid

  include Display

  def self.blank_board
    Board.new(false)
  end

  def initialize(empty_board = true)
    @grid = Array.new(8) { Array.new(8) }
    @cursor = [0,0]
    populate_grid if empty_board
  end

  def [](pos)
    x,y = pos
    @grid[x][y]
  end

  def []=(pos,value)
    @grid[pos[0]][pos[1]] = value
  end

  def populate_grid
    @grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        pos = [i,j]
        if (i == 0 || i == 2) && j.odd? || i == 1 && j.even?
          self[pos] = Piece.new("White",[i,j],self)
        elsif i == 6 && j.odd? || (i == 5 || i == 7) && j.even?
          self[pos] = Piece.new("Black",[i,j],self)
        else
          self[pos] = EmptySpace.new([i,j])
        end
      end
    end
  end

  def render
    @grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if [i,j] == @cursor
          print " #{cell.symbol}  ".colorize(background: :yellow)
        elsif self[@cursor].valid_moves.include?([i,j])
          print " #{cell.symbol}  ".colorize(background: :green)
        elsif (i.odd? && j.even?) || (i.even? && j.odd?)
          print " #{cell.symbol}  ".colorize(background: :red)
        elsif (i.even? && j.even?) || (i.odd? && j.odd?)
          print " #{cell.symbol}  ".colorize(background: :blue)
        else
          print " #{cell.symbol}  "
        end
      end
      puts
    end
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end

  def empty_space?(pos)
    self[pos].is_a?(EmptySpace)
  end

  def black_win?
    return @grid.flatten.none? {|piece| piece.color == "White" }
  end

  def white_win?
    return @grid.flatten.none? { |piece| piece.color == "Black" }
  end

  def deep_dup
    duped_board = Board.blank_board

    grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        duped_board[[i,j]] = cell.dupe(duped_board)
      end
    end

    duped_board
  end

end
