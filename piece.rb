require_relative 'module'
require 'byebug'
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

  def valid_moves(start, end_pos, pos_moves = nil)
    #create a copy of board
    #check if the position will put us in check
    #filter out moves that will put us in check

    # if pos moves isnt nil, iterate thru pos_moves
     if !pos_moves.include?(end_pos)
       return false
     elsif @board.blocked_route?(start, end_pos, pos_moves)
       return false
     else
       board_copied = board.board_dup
       board_copied[end_pos] = board[start]
       board_copied[start] = NullPiece.new(nil, nil, self)
       !board_copied.in_check?(self.color)
     end
     true
   end
    # if our piece is on any square, dont push
    #elsif ...

    #comb through moves and select ones that are not in check and not bocked

      #valid_route(start, end_pos)
      # how the pawn knows whether it is attacking or not
      # check whether place its moving to has a piece or not
      # check what color piece is





    #check what piece it is
    #have piece class check if it is valid or not
    #call valid_route? in piece class to check if it is blocked
    #in_check?


  def piece_dup(new_board)
    self.class.new(self.color, self.pos.dup, new_board)
  end
end

# print Pawn.new

class Pawn < Piece

  def initialize(color, pos, board)
    super
    @moved = false
  end

  attr_accessor :moved

  def to_s
    color == "white" ? " \u2659 " : " \u265f "
  end

  MOVE_UP = [[2,0],[1,0]]
  DIAG = [[1, -1], [1, 1]]
  def moves(start_pos)
    moves = []
    debugger
    MOVE_UP.each do |pos|
      #change pawn's moved instance variable after being moved
      next if self.moved
      if self.color == "white"
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
      if self.color == "white"
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
    color == "white" ? " \u2657 " : " \u265d "
  end

  def moves(start_pos)
    pos_moves = []
    DIAG_MOVES_DIFF.each do |dirc|
      pos_moves += slide_moves(start_pos, dirc)
    end
    pos_moves
  end
end

class Rook < Piece
  include SlidingPiece

  def to_s
    color == "white" ? " \u2656 " : " \u265c "
  end

  def moves(start_pos)
    pos_moves = []
    NORMAL_MOVES_DIFF.each do |dirc|
      pos_moves += slide_moves(start_pos, dirc)
    end
    pos_moves
  end
end

class Knight < Piece
  include SteppingPiece
  def to_s
    color == "white" ? " \u2658 " : " \u265e "
  end

  def moves(start_pos)
    knight_moves(start_pos)
  end
end

class Queen < Piece
  include SlidingPiece
  def to_s
    color == "white" ? " \u2655 " : " \u265b "
  end
    #print out pos moves without in_check or end_pos check
  def moves(start_pos)
    pos_moves = []
    (DIAG_MOVES_DIFF + NORMAL_MOVES_DIFF).each do |dirc|
      pos_moves += slide_moves(start_pos, dirc)
    end
    pos_moves
  end

end

class King < Piece
  include SteppingPiece
  def to_s
    color == "white" ? " \u2654 " : " \u265a "
  end

  def moves(start_pos)
    king_moves(start_pos)
  end
end

class NullPiece < Piece
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
end
