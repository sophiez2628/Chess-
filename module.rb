module SlidingPiece
  #bishop, rook, queen

  #iterate through possible moves until it hits an piece that is occupied

  DIAG_MOVES_DIFF = [[1,1],[1,-1],[-1,1],[-1,-1]]
  NORMAL_MOVES_DIFF = [[1,0],[-1,0],[0,1],[0, -1]]

 # Dry out functionality into slide
  def slide_moves(start_pos, dirc) # this returns array of every move possible from one spot (not considering end_pos)
    #debugger
    moves = []
    until !board.in_bounds?(start_pos) || board.occupied?(start_pos, self.color)
      row_idx = dirc.first + start_pos.first
      col_idx = dirc.last + start_pos.last
      moves += [row_idx, col_idx]
      start_pos = [row_idx, col_idx]
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


    #occupied receives message from board


    # what do we call occupied on without instance of board
    # third var thats passed in based on results of occupied method
    # so if occupied true, then run. dont forget to check color

    # check to see if theres a piece in the diag. if there is, add those moves
