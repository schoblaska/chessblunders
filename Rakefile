require './lib/chess_blunders'

task :console do
  binding.pry
end

task :annotate do
  input_file = ENV['FILE'] || ENV['file']

  unless input_file
    desktop = File.join(`echo ~`.strip, "Desktop/")
    file_name = `ls #{desktop}`.split("\n").find{|f| f =~ /\.pgn$/}
    input_file = file_name ? File.join(desktop, file_name) : nil
  end

  raise "Must provide a PGN file to annotate." unless input_file

  output_file = ENV['OUTPUT'] || ENV['output'] || input_file.gsub(/\.pgn$/, '_out.pgn')

  ChessBlunders.annotate(input_file, output_file)

  `open #{output_file}`
end
