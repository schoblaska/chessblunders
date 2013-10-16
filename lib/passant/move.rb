module Passant
  
  # Move of a piece.
  class Move
    attr_reader :piece, :from, :to
    attr_accessor :comment, :alg
    
    def initialize(piece, move_to)
      @comment = nil
      @piece = piece
      @from = piece.position
      @to = move_to
      @capture_piece = @piece.board.at(@to)
    end
    
    def apply
      @capture_piece.capture if @capture_piece
      @piece.position = @to
      @piece.history << self
      @piece.board.add_history(self)
      @piece.board.clear_takebacks_after(self)
      self
    end
  
    def take_back
      @capture_piece.uncapture if @capture_piece
      @piece.position = @from
      @piece.history.delete(self)
      @piece.board.remove_history(self)
      @piece.board.add_takeback(self)
      self
    end
    
    def to_s
      l = @piece.board.letter_for_piece(@piece)
      c = capture? ? 'x' : ''
      "#{l}#{chess_coords(@from)}#{c}#{chess_coords(@to)}"
    end
    
    def to_pgn
      if @comment and @comment.length > 0
        self.alg + " {#{@comment}}"
      else
        self.alg
      end
    end

    def to_alg
      ''.tap do |output|
        l = @piece.board.letter_for_piece(@piece)
        output << l.upcase unless l.downcase == 'p'

        moves = @piece.board.all_moves(@piece.color).select do |move|
          move.to == to &&
            move.from != from &&
            move.piece.class == self.class
        end

        if l.downcase == 'p' && capture?
          output << chess_coords(@from)[0,1]
        end

        unless moves.empty?
          if moves.select{|m| m.from[0] == from[0]}.empty?
            output << chess_coords(@from)[0,1] unless l.downcase == 'p' && capture?
          elsif moves.select{|m| m.from[1] == from[1]}.empty?
            output << chess_coords(@from)[1,1]
          else
            output << chess_coords(@from)
          end
        end

        output << 'x' if capture?
        output << chess_coords(@to)
      end
    end

    def to_uci
      "#{chess_coords(@from)}#{chess_coords(@to)}"
    end

    def capture?
      !@capture_piece.nil?
    end

    def participants; [@piece, @capture_piece].compact end
    
    def inspect; to_s; end
    
  end # class Move

end
