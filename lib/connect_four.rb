require "connect_four/version"
require "connect_four/board.rb"
module ConnectFour
  # Your code goes here...

  class ConnectFour

    def initialize
      @board = Board.new
      @turn_number = 0
      setup_and_welcome_players
    end

    def play
      until @board.game_over?
        colnum = take_turn
        @board.make_move(current_player, colnum)
        turn_number += 1
      end

      gm_over = @board.game_over?
      if gm_over == :tie
        puts "Game is a tie!"
      else
        puts "#{ player(current_player) } wins!"
        puts "Goodbye!"
    end

    private

    def take_turn
      puts "The current board is below."
      puts @board
      puts "Which column do you want to place your piece?"
      colnum = gets.chomp.to_i
      puts "-" * 70
      return colnum
    end

    def setup_and_welcome_players
      puts "Welcome to Conncet Four!"
      puts "-------------------------------"
      puts "What is the name of Player 1?"
      @player_1 = gets.chomp
      puts "What is the name of Player 2?"
      @player_2 = gets.chomp
      puts "-------------------------------"

    end

    def current_player
      turn_number.even? ? :player_1 : :player_2
    end

    def player(symb)
      return @player_1 if symb == :player_1
      return @player_2 if symb == :player_2
      nil
    end

  end
end

game = ConnectFour::ConnectFour.new
game.play
