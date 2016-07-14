require_relative 'tile'
require 'byebug'
class Board

  #attr_reader :grid

  def initialize(size = 9, num_bombs = 10)
    @grid = Array.new(size) do |row|
      Array.new(size) {Tile.new}
    end
    @got_bombed = false
    @bomb_pos = place_bombs(num_bombs)
    @num_flags_left = num_bombs
  end

  def size
    @grid.size
  end

  def over?
    all_revealed? || @got_bombed
  end

  def render
    puts "  #{(0...size).to_a.join(" ")}"
    @grid.each_with_index do |row, i|
      puts "#{i}|#{row.join(" ")}"
    end
  end

  def reveal_bombs
    # @bomb_pos.each do 
  end

  def play_move(pos)
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  private
  def place_bombs(num_bombs)
    bomb_list = []
    until bomb_list.size == num_bombs
      row, col = (0...size).to_a.sample, (0...size).to_a.sample
      unless bomb_list.include?([row, col])
        bomb_list << [row, col]
        self[[row, col]].is_bomb = true
        increment_neighbor_value(row, col)
      end
    end
    bomb_list
  end

  def increment_neighbor_value(row, col)
    (-1..1).to_a.each do |x_dir|
      (-1..1).to_a.each do |y_dir|
        neigh_x, neigh_y = row + x_dir, col + y_dir
        neigh_pos = [row + x_dir, col + y_dir]
        next unless (0...size).include?(neigh_x) &&
          (0...size).include?(neigh_y) && [x_dir, y_dir] != [0,0]
        self[neigh_pos].value += 1
      end
    end
  end

  def reveal_tiles(pos)
  end
end

board = Board.new(9, 3)
board.render
