require_relative "board"
require_relative "player"

class Game
  attr_accessor :board, :player_1, :player_2, :current_player

  def initialize
    @board = Board.new
    @player_1 = Player.new(@board, :white)
    @player_2 = Player.new(@board, :black)
  end

  def play
    @current_player = player_1
    until game_over?
      selected_pos = current_player.move_cursor # gets input from move_cursor method
      set_pos = current_player.move_cursor # gets input form move_cursor method
      board.move_piece(@current_player.color, selected_pos, set_pos) # tells board to validate and move piece
      swap_player!
    end
  end

  def game_over?
    if board.checkmate?(current_player.color)
      puts "Game over! #{current_player.color} loses!"
      return true
    end
    false
  end

  def swap_player!
    if self.current_player == player_1
      self.current_player = player_2
    else
      self.current_player = player_1
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
