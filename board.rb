require_relative "piece"
require_relative "display"
require 'byebug'
require 'Set'

class Board
  attr_accessor :grid

  def initialize(setup_board = true)
    @null_piece = NullPiece.instance
    populate if setup_board
  end

  def populate
    @grid = Array.new(8) { Array.new(8, null_piece )}
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end
  #piece class will verify if it is a valid move
  def in_check?(color)
      king_pos = find_king(color)
      grid.each_with_index do |row, row_idx|
        row.each_with_index do |piece, col_idx|
          #debugger if row_idx == 0 && col_idx == 6
          return true if piece.color != color && piece.moves([row_idx, col_idx]).include?(king_pos)
        end
      end
      false
  end
      #iterate through all the moves of the other board's pieces and check if king's position is include

  def find_king(color)
    self.grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        return [row_idx, col_idx] if piece.is_a?(King) && piece.color == color
      end
    end
  end

  def checkmate?(color)
    #no more valid moves for king
    #find all the valid moves of the king and determine if all of them are in the pos positions of the opponent
    king_pos = find_king(color) #color of the current player
    king_moves = self.grid[king_pos.first][king_pos.last].moves(king_pos)
    opp_moves = Set.new
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        opp_moves += piece.moves([row_idx, col_idx]) if piece.color != color
      end
    end
    debugger
    #king_moves.empty? ? false : king_moves.all? { |king_move| opp_moves.include?(king_move) }

  end

  def board_dup
    # board_dup = self.dup
    # iterate thru board_dup, for each spot,  do piece.dup and pass board_dup
    new_board = Board.new(false)
    self.grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        #debugger
        new_board.grid[row_idx][col_idx] = piece.piece_dup(new_board)
      end
    end
    new_board
  end
  ###################
  def move_piece(start, end_pos)
#debugger
    if self.in_check?(self.grid[start.first][start.last].color)
      # only validate moves that take current player of check
      # if player cant get out of check, thats a checkmate

    elsif self[start].valid_move?(start, end_pos)
      #move piece
      self[end_pos] = self[start]
      self[start] = NullPiece.new(nil, nil, self)
    else
      #raise error
    end
  end


  def blocked_route?(start, end_pos, pos_moves)
    #after making sure that end_pos is one of the possible moves, check that the route is clear
    # consider whether blocked by own color or opp color
    pos_moves.each do |move|
      if self[end_pos].color == self[start].color
        return true
      elsif move.first > start.first && move.first < end_pos.first && move.last > start.last && move.last < end_pos.last
        return true if self[move].class != NullPiece
      end
    end
    false
  end

  def occupied?(pos, own_color)
    # if occupied true, return piece. if false, return false
    #debugger
    if self.grid[pos.first][pos.last].is_a?(NullPiece)
      false
    elsif self.grid[pos.first][pos.last].color != own_color
      false
    else
      true
    end
  end


  def full?
    @grid.all? do |row|
      row.all? { |piece| piece.present? }
    end
  end



  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def rows
    @grid
  end
end

new_board = Board.new
new_display = Display.new(new_board)
new_display.render
