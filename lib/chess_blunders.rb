require 'rubygems'
require 'bundler'

Bundler.require

require './lib/passant'
require './lib/ruby_uci'

class ChessBlunders
  def self.annotate(pgn_file, output)
    cb = self.new(pgn_file)
    cb.evaluate_moves
    cb.find_blunders
  end

  def initialize(pgn_file)
    @pgn = Passant::PGN::File.new(pgn_file)
    @moves = @pgn.games.first.to_board.history
    @uci = RubyUCI.new('stockfish', 12)
  end

  def evaluate_moves
    @evaluations = []

    @moves.each_with_index do |move, i|
      @uci.moves = i == 0 ? '' : @moves[0..i-1].map{|m| m.to_uci}.join(' ')
      evaluation = @uci.evaluate(move.to_uci)[:score][:num]
      evaluation *= -1 unless i%2 == 0
      @evaluations << evaluation
    end
  end

  def find_blunders
    @blunders = {}

    @evaluations.each_with_index do |evaluation, i|
      previous = i == 0 ? 0 : @evaluations[i-1]
      difference = (evaluation - previous).abs

      if difference >= 3
        @blunders[i] = '??'
      elsif difference >= 1
        @blunders[i] = '?'
      end
    end
  end
end
