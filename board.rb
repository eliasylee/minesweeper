require_relative 'tile'
require 'byebug'

class Board

  attr_reader :check_pos

  def initialize(size = 9, num_bombs = 10)
    @grid = Array.new(size) do |row|
      Array.new(size) {Tile.new}
    end
    @got_bombed = false
    @bomb_pos = place_bombs(num_bombs)
    @num_flags_left = num_bombs
    @checked_pos = []
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
    p @bomb_pos # FIX ME
  end

  def reveal_bombs
    @bomb_pos.each do |pos|
      self[pos].reveal
    end
  end

  def play_move(pos, action)
    if action == :f
      self[pos].is_flagged = self[pos].is_flagged ? false : true
    else
      if self[pos].is_bomb
        @got_bombed = true
      else
        revealed_tiles = reveal_tiles_list(pos)
        revealed_tiles.each {|pos| self[pos].reveal}
      end
    end
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def place_bombs(num_bombs)
    bomb_list = []
    until bomb_list.size == num_bombs
      pos = [(0...size).to_a.sample, (0...size).to_a.sample]
      unless bomb_list.include?(pos)
        bomb_list << pos
        self[pos].is_bomb = true
        increment_neighbor_value(pos)
      end
    end
    bomb_list
  end

  def increment_neighbor_value(pos)
    row, col = pos
    (-1..1).to_a.each do |x_dir|
      (-1..1).to_a.each do |y_dir|
        neigh_pos = [row + x_dir, col + y_dir]
        next unless valid_neighbor?(pos, neigh_pos)
        self[neigh_pos].value += 1
      end
    end
  end

  def valid_neighbor?(pos, neigh_pos)
    neigh_x, neigh_y = neigh_pos
    (0...size).include?(neigh_x) &&
      (0...size).include?(neigh_y) &&
        pos != neigh_pos
  end

  def reveal_tiles_list(pos)
    row, col = pos
    @checked_pos << pos
    return [] if self[pos].is_flagged || self[pos].is_bomb
    return [pos] if self[pos].value > 0
    result = [pos]
    (-1..1).to_a.each do |x_dir|
      (-1..1).to_a.each do |y_dir|
        neigh_pos = [row + x_dir, col + y_dir]
        if valid_neighbor?(pos, neigh_pos) && !@checked_pos.include?(neigh_pos)
          result += reveal_tiles_list(neigh_pos)
        end
      end
    end
    result
  end
end
