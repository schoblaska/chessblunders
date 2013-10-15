module Passant
end

require "#{File.dirname(__FILE__)}/passant/piece"

require "#{File.dirname(__FILE__)}/passant/pieces/bishop"
require "#{File.dirname(__FILE__)}/passant/pieces/king"
require "#{File.dirname(__FILE__)}/passant/pieces/knight"
require "#{File.dirname(__FILE__)}/passant/pieces/queen"
require "#{File.dirname(__FILE__)}/passant/pieces/pawn"
require "#{File.dirname(__FILE__)}/passant/pieces/rook"

require "#{File.dirname(__FILE__)}/passant/board"
require "#{File.dirname(__FILE__)}/passant/move"
require "#{File.dirname(__FILE__)}/passant/castling"
require "#{File.dirname(__FILE__)}/passant/en_passant"
require "#{File.dirname(__FILE__)}/passant/pgn"
require "#{File.dirname(__FILE__)}/passant/game_board"
require "#{File.dirname(__FILE__)}/passant/move_parser"
require "#{File.dirname(__FILE__)}/passant/promotion"
require "#{File.dirname(__FILE__)}/passant/rules_engine"
require "#{File.dirname(__FILE__)}/passant/squares"
