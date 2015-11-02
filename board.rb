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
    # break down tasks
    [:black, :white].each do |color|
      fill_back_row(color)
      fill_front_row(color)
    end
  end

  def add_piece(pos, piece)
    self[pos] = piece
  end

  def fill_back_row(color)
    back_row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    #ternary statement has a return value
    i = (color == :white ? 7 : 0)
    back_row.each_with_index do |piece, index|
      pos = [i, index]
      new_piece = piece.new(color, pos, self)
      add_piece(pos, new_piece)
    end

  end

  def fill_front_row(color)
    i = (color == :white ? 6 : 1 )
    8.times.each do |index|
      pos = [i, index]
      new_piece = Pawn.new(color, pos, self )
      add_piece(pos, new_piece)
    end
  end


  #note that this method takes in one argument!
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
    king_pos = find_king(color).pos
    pieces.any? do |piece|
      piece.color != color && piece.moves(piece.pos, piece.moves_dirc).include?(king_pos)
    end
  end

  def pieces
    grid.flatten.reject { |piece| piece.empty? }
  end

  def find_king(color)
    pieces.find { |piece| piece.color == color && piece.is_a?(King) }
  end

  def checkmate?(color)
    return false unless in_check(color)
    king = find_king(color)
    pieces.select {|piece| piece.color == color }.all? { |piece| piece.valid_moves.empty? }

  end

  def dup
    new_board = Board.new(false)
    self.grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        new_board.grid[row_idx][col_idx] = piece.piece_dup(new_board)
      end
    end
    new_board
  end

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

  private
  attr_reader :null_piece
end
