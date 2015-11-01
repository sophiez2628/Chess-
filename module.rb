module SlidingPiece
  #bishop, rook, queen

  DIAG_MOVES_DIRC = [[1,1],[1,-1],[-1,1],[-1,-1]]
  NORMAL_MOVES_DIRC = [[1,0],[-1,0],[0,1],[0, -1]]

  def diag_moves_dirc
    DIAG_MOVES_DIRC
  end

  def normal_moves_dirc
    NORMAL_MOVES_DIRC
  end

  def moves(start_pos, moves_dirc)
    moves = []

    moves_dirc.each do |dirc|
      until !board.in_bounds?(start_pos) || board.occupied?(start_pos, self.color)
        row_idx = dirc.first + start_pos.first
        col_idx = dirc.last + start_pos.last
        moves += [row_idx, col_idx]
        start_pos = [row_idx, col_idx]
      end
    end
      moves
  end


end

module SteppingPiece
  #knight, king
  KNIGHT_MOVES_DIFF = [[-2,1], [2, -1], [2,1], [-2,-1],[-1,2],[1,-2],[-1,-2],[1,2]]
  KING_MOVES_DIFF = [[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1]]
  def knight_moves(start_pos)
    moves = []
    KNIGHT_MOVES_DIFF.each do |diff|
      x = diff.first - start_pos.first
      y = diff.last - start_pos.last
      #debugger
      next if board.occupied?([x,y], self.color)
      moves << [x, y] if board.in_bounds?([x,y])
    end
    moves
  end

  def king_moves(start_pos)
    moves = []
    KING_MOVES_DIFF.each do |diff|
      x = diff.first - start_pos.first
      y = diff.last - start_pos.last
      next if board.occupied?([x,y], self.color)
      moves << [x, y] if board.in_bounds?([x,y])
    end
    moves
  end


end
