require_relative 'module'
require 'byebug'
require 'singleton'
class Piece
  attr_reader :color, :board
  attr_accessor :pos
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

  def to_s
    color == :white ? " \u2659 " : " \u265f "
  end

  def empty?
    false
  end

  MOVE_FORWARD = [[2,0],[1,0]]
  MOVE_DIAG = [[1, -1], [1, 1]]

  def moves
    forward_steps + diag_steps
  end

  def at_starting_row?
    pos.first == ((color == :white) ? 6 : 1)
  end

  def forward_dirc
    color == :white ? -1 : 1
  end

  def forward_steps
    moves = []
    row_idx, col_idx = pos

    two_step = [row_idx + forward_dirc * 2, col_idx]
    if at_starting_row? && !board.occupied?(two_step, color)
      moves << [row_idx + forward_dirc * 2, col_idx]
    end

    one_step = [row_idx + forward_dirc, col_idx]
    if board.in_bounds?(one_step) && !board.occupied?(one_step, color)
      moves << one_step
    end

    moves
  end

  def diag_steps
    row_idx, col_idx = pos
    side_moves = [[row_idx + forward_dirc, col_idx - 1], [row_idx + forward_dirc, col_idx + 1]]

    side_moves.select do |move|
      next false if board[move].is_a?(NullPiece)
      board.in_bounds?(move) && board[move].color != color
    end

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

  def empty?
    false
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

  KNIGHT_MOVES_DIFF = [[-2,1], [2, -1], [2,1], [-2,-1],[-1,2],[1,-2],[-1,-2],[1,2]]

  def to_s
    color == :white ? " \u2658 " : " \u265e "
  end

  def empty?
    false
  end

  def moves_dirc
    KNIGHT_MOVES_DIFF
  end
end


class King < Piece
  include SteppingPiece

  KING_MOVES_DIFF = [[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1]]

  def to_s
    color == :white ? " \u2654 " : " \u265a "
  end

  def empty?
    false
  end

  def moves_dirc
    KING_MOVES_DIFF
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

  def valid_moves
    []
  end


  def moves(start_pos)
    []
  end

  def empty?
    true
  end

  def piece_dup(new_board)
    NullPiece.instance
  end
end
