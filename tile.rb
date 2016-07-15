require 'colorize'

class Tile

  COLORS = {1 => :blue,
            2 => :green,
            3 => :pink,
            4 => :light_blue,
            5 => :magenta,
            6 => :cyan,
            7 => :light_red,
            8 => :light_green}

  attr_accessor :is_revealed, :is_flagged, :value, :is_bomb

  def initialize
    @is_bomb = false
    # FIX ME
    @is_revealed = false
    @is_flagged = false
    @value = 0
  end

  def to_s
    if @is_revealed
      @is_bomb ? "X".colorize(:red) : "#{@value}".colorize(COLORS[@value])
    else
      @is_flagged ? "?".colorize(:yellow) : "_"
    end
  end

  def reveal
    @is_revealed = true
  end

  def toggle_flag
    unless is_revealed
      @is_flagged = @is_flagged ? false : true
    end
  end

end
