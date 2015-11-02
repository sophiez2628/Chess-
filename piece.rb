require_relative 'module'
require 'byebug'
require 'singleton'
class Piece
  attr_reader :color, :pos, :board
  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
  end

  def present?
    true
  end

  def to_s
    " x "
  end

  def move_into_check?(to_pos)
    board_copied = board.dup
    #what class is responsible for what action?
    board_copied.move_piece!(pos, to_pos)
    board_copied.in_check?(color)
  end

  def valid_moves
    self.moves.select do |move|
      !self.move_into_check?(move)
    end
  end

  def valid_move?(end_pos)
    self.valid_moves.include?(end_pos)
  end


  def piece_dup(new_board)
    self.class.new(self.color, self.pos.dup, new_board)
  end
end



class Pawn < Piece

  def initialize(color, pos, board)
    super
    @moved = false
  end

  attr_accessor :moved

  def to_s
    color == :white ? " \u2659 " : " \u265f "
  end

  def empty?
    false
  end

  MOVE_UP = [[2,0],[1,0]]
  DIAG = [[1, -1], [1, 1]]
  def moves(start_pos)
    moves = []
    debugger
    MOVE_UP.each do |pos|
      #change pawn's moved instance variable after being moved
      next if self.moved
      if self.color == :white
        row_idx = pos.first + start_pos.first
        col_idx = pos.last + start_pos.first
        #debugger

        moves += [row_idx, col_idx] if board.in_bounds?([row_idx, col_idx]) && board.grid[row_idx][col_idx].is_a?(NullPiece)
      else
        row_idx = pos.first - start_pos.first
        col_idx = pos.last - start_pos.first
        moves += [row_idx, col_idx] if board.in_bounds?([row_idx, col_idx]) && board.grid[row_idx][col_idx].is_a?(NullPiece)
      end
    end

    DIAG.each do |pos|
      if self.color == :white
        row_idx = pos.first + start_pos.first
        col_idx = pos.last + start_pos.first
        moves += [row_idx, col_idx] if board.in_bounds?([row_idx, col_idx]) && board.grid[row_idx][col_idx].color != self.color
      else
        row_idx = pos.first - start_pos.first
        col_idx = pos.last - start_pos.first
        moves += [row_idx, col_idx] if board.in_bounds?([row_idx, col_idx]) && board.grid[row_idx][col_idx].color != self.color
      end
    end
    moves
  end


end

class Bishop < Piece
  include SlidingPiece
  def to_s
    color == :white ? " \u2657 " : " \u265d "
  end

  def empty?
    false
  end

  def moves_dirc
    DIAG_MOVES_DIRC
  end

end

class Rook < Piece
  include SlidingPiece

  def to_s
    color == :white ? " \u2656 " : " \u265c "
  end

  def moves_dirc
    NORMAL_MOVES_DIRC
  end


end

class Queen < Piece
  include SlidingPiece
  def to_s
    color == :white ? " \u2655 " : " \u265b "
  end

  def empty?
    false
  end

  def moves_dirc
    DIAG_MOVES_DIRC + NORMAL_MOVES_DIRC
  end

end

class Knight < Piece
  include SteppingPiece
  def to_s
    color == :white ? " \u2658 " : " \u265e "
  end

  def empty?
    false
  end

  def moves(start_pos)
    knight_moves(start_pos)
  end
end


class King < Piece
  include SteppingPiece
  def to_s
    color == :white ? " \u2654 " : " \u265a "
  end

  def moves(start_pos)
    king_moves(start_pos)
  end

  def empty?
    false
  end
end

class NullPiece
  include Singleton


  def present?
    false
  end

  def to_s
    "   "
  end

  def pos
    []
  end

  def moves(start_pos)
    []
  end

  def empty?
    true
  end
end
