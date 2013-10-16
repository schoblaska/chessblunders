require './lib/chess_blunders'

task :console do
  binding.pry
end

task :test do
  ChessBlunders.annotate("/tmp/chess.pgn", "/tmp/chessout.pgn")
end
