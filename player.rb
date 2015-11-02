require_relative "display"

class Player
  attr_reader :color

  def initialize(board, color)
    @display = Display.new(board)
    @color = color
  end

  def move_cursor
    result = nil
    until result
      @display.render
      result = @display.get_input
    end
    result
  end

end
