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

  def moves
    moves = []

    moves_dirc.each do |dirc|
      until !board.in_bounds?(pos) || board.occupied?(pos, self.color)
        row_idx = dirc.first + pos.first
        col_idx = dirc.last + pos.last
        moves << [row_idx, col_idx]
        pos = [row_idx, col_idx]
      end
    end
      moves
  end


end

module SteppingPiece
  #knight, king
  def moves
    moves = []
    moves_dirc.each do |dirc|
      row_idx = pos[0] + dirc[0]
      col_idx = pos[1] + dirc[1]
      if board.in_bounds?([row_idx, col_idx]) && !board.occupied?([row_idx, col_idx], self.color)
        moves << [row_idx, col_idx]
      end
    end
    moves
  end

end
