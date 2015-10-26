require_relative "./connect_four/version"
require_relative "./connect_four/board.rb"
module ConnectFour

  P1_REPRESENTATION = "\u26AB"
  P2_REPRESENTATION = "\u26AA"
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
        @turn_number += 1
      end

      gm_over = @board.game_over?
      puts @board
      if gm_over == :tie
        puts "Game is a tie!"
      else
        @turn_number -= 1
        puts "#{ player(current_player) } wins!"
        puts "Goodbye!"
      end
    end

    private

    def take_turn
      puts "It is #{current_player}'s turn."
      puts "The current board is below."
      puts @board
      puts "#{@player_1}: #{P1_REPRESENTATION}"
      puts "#{@player_2}: #{P2_REPRESENTATION}"
      puts "Which column do you want to place your piece in, #{player(current_player)}?"
      colnum = get_col_from_user
      puts "-" * 70
      return colnum
    end

    def get_col_from_user
      x = gets.chomp.to_i
      valid_choices = (0...@board.n_cols).to_a
      until valid_choices.include?(x) && !@board.col_full?(x)
        puts "Sorry, that column is full." if @board.col_full?(x)
        puts "Please choose a column number from 0 - #{@board.n_cols - 1}."
        x = gets.chomp.to_i
      end
      return x
    end

    def setup_and_welcome_players
      puts "Welcome to Connect Four!"
      puts "-------------------------------"
      puts "What is the name of Player 1?"
      @player_1 = gets.chomp
      puts "What is the name of Player 2?"
      @player_2 = gets.chomp
      puts "-------------------------------"

    end

    def current_player
      @turn_number.even? ? :player_1 : :player_2
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
