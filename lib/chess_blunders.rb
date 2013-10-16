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
    cb.annotate_moves
    cb.write_pgn(output)
  end

  def initialize(pgn_file)
    @pgn = Passant::PGN::File.new(pgn_file)
    @board = @pgn.games.first.to_board
    @uci = RubyUCI.new('stockfish', 16)
  end

  def evaluate_moves
    @evaluations = []

    @board.history.each_with_index do |move, i|
      @uci.moves = i == 0 ? '' : @board.history[0..i-1].map{|m| m.to_uci}.join(' ')
      evaluation = @uci.evaluate(move.to_uci)[:score][:num]
      evaluation *= -1 unless i%2 == 0
      @evaluations << evaluation
    end
  end

  def find_blunders
    @blunders = {}

    @evaluations.each_with_index do |evaluation, i|
      previous = i == 0 ? 0 : @evaluations[i-1]
      worsening = evaluation - previous
      worsening *= -1 if i % 2 == 0

      if worsening >= 3
        @blunders[i] = '??'
      elsif worsening >= 1
        @blunders[i] = '?'
      end
    end
  end

  def annotate_moves
    @blunders.keys.each do |k|
      @board.history[k].comment = @blunders[k]
    end
  end

  def write_pgn(output)
    File.open(output, 'w') {|f| f.puts @board.to_pgn}
  end
end
