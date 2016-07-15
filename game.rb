require_relative 'board'
require_relative 'tile'

class Game

  def initialize(size, num_bombs)
    @board = Board.new(size, num_bombs)
    @board_size = @board.size
  end

  def play
    until @board.over?
      @board.render

      play_turn
    end
    @board.render
    if @board.all_revealed?
      puts "yay you won!"
    else
      @board.reveal_bombs
      puts "you lost"
    end
  end

  def play_turn
    pos = nil
    action = nil
    until valid_pos?(pos) && valid_action?(action)
      puts "Enter your move in the format action,x,y (r or f)"
      begin
        input = parse_input(gets.chomp)
        action = get_action(input)
        pos = get_pos(input)
      rescue StandardError => e
        puts "Invalid input: #{e}"
      end
    end
    @board.play_move(pos, action)
  end

  def parse_input(input)
    input.split(",")
  end

  def get_pos(input)
    [input[1].to_i, input[2].to_i]
  end

  def get_action(input)
    input[0].to_sym
  end

  def valid_pos?(pos)
    return false if pos.nil?
    x, y = pos
    p x, y
    (0...@board_size).include?(x) && (0...@board_size).include?(y)
  end

  def valid_action?(action)
    action == :f || action == :r
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new(5, 5).play
end
