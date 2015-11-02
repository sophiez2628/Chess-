require "colorize"
require_relative "cursorable"

class Display
  include Cursorable

  attr_reader :board, :cursor_pos

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
  end

  def build_grid
    board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == cursor_pos
      bg = :light_red
    elsif board[cursor_pos].valid_moves.include?([i, j])
      bg = :yellow
    elsif (i + j).odd?
      bg = :light_blue
    else
      bg = :blue
    end
    { background: bg }
    # { background: bg, color: :white }
  end


  def render
    system("clear")
    build_grid.each_with_index { |row, index| puts row.join }
  end
end
