require_relative 'display.rb'
require_relative 'piece.rb'
require 'colorize'

class Board

  attr_accessor :grid

  include Display

  def initialize
    @grid = Array.new(8) { Array.new(8){} }
    @cursor = [0,0]
    populate_grid
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos,value)
    @grid[pos[0]][pos[1]] = value
  end

  def populate_grid
    @grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        pos = [i,j]
        if (i == 0 || i == 2) && j.odd? || i == 1 && j.even?
          self[pos] = Piece.new("red",[i,j],grid)
        elsif i == 6 && j.odd? || (i == 5 || i == 7) && j.even?
          self[pos] = Piece.new("black",[i,j],grid)
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
        elsif (i.odd? && j.even?) || (i.even? && j.odd?)
          print " #{cell.symbol.colorize(:red)}  ".colorize(background: :red)
        elsif (i.even? && j.even?) || (i.odd? && j.odd?)
          print " #{cell.symbol}  ".colorize(background: :blue)
        else
          print " #{cell.symbol}  "
        end
      end
      puts
    end
  end


end

b = Board.new
b.render
