class RubyUCI
  attr_accessor :moves

  def initialize(engine, depth)
    @engine = engine
    @depth = depth
    @moves = ''
  end

  def best
    result = uci_pipe do |pipe|
      pipe.puts("go depth #{@depth}")
    end

    {:line => result.scan(/([a-z]\d[a-z]\d[a-z]{0,1})/).flatten, :score => score_from_string(result)}
  end

  def evaluate(move)
    result = uci_pipe do |pipe|
      pipe.puts("go depth #{@depth} searchmoves #{move}")
    end

    {:line => result.scan(/([a-z]\d[a-z]\d[a-z]{0,1})/).flatten, :score => score_from_string(result)}
  end

  private

  def uci_pipe
    IO.popen(@engine, 'r+') do |pipe|
      begin
        pipe.puts('uci')
        pipe.puts("position startpos moves #{moves}") unless moves.length == 0
        yield(pipe) if block_given?

        lines = [pipe.gets]
        lines << pipe.gets until lines.last =~ /bestmove/

        lines.select{|l| l =~ /cp\s.*pv/ || l =~ /score\s.*pv/}.last.chomp
      ensure
        pipe.close
      end
    end
  end

  def score_from_string(string)
    if match = string.match(/\scp\s(\S*)/)
      score = match[1].to_i / 100.0
      {:num => score, :str => score.to_s}
    else
      match = string.match(/\sscore\smate\s(\S*)/)
      {:num => 10000 / match[1].to_i, :str => "##{match[1]}"}
    end
  end
end
