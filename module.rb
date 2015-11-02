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
      new_pos = self.pos
      new_pos = add_pos_dirc(new_pos, dirc)
      until !board.in_bounds?(new_pos)
        if !board.occupied?(new_pos, self.color)
          moves << new_pos
          new_pos = add_pos_dirc(new_pos, dirc)
        else
          new_pos = [100, 100]
        end
      end
    end

      moves
  end

  def add_pos_dirc(pos, dirc)
    [pos.first + dirc.first, pos.last + dirc.last]
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
