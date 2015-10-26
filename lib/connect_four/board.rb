module ConnectFour

	class Board

		attr_reader :n_rows, :n_cols, :positions, :p1_representation, :p2_representation

		def initialize(row = 6, col = 7)
			raise ArgumentError if (row < 4 || col < 4)
			@n_rows = row
			@n_cols = col
			@positions = setup(row, col)
			@@p1_representation = "\u26AB" #white disc
			@@p2_representation = "\u26AA" #empty disc
		end

		def entry(r, c)
			raise ArgumentError if (	r < 0 || r >= @n_rows || c < 0 || c >= @n_cols)
			@positions[r][c]
		end

		def make_move(player, column)
			row = lowest_available_index(column)
			raise ArgumentError if row.nil?
			raise ArgumentError if player.nil?
			@positions[row][column] = player
		end

		def make_moves(first_player, *args)
			args = args.first if args.first.is_a?(Array)
			#make sure args is an array args = (args.first.class)
			player = first_player
			args.each do |column|
				make_move(player, column)
				player = (player == :player_1 ? :player_2 : :player_1)
			end
		end

		def game_over?(find_winner = false)
			gm_over = vertical_game_over?(find_winner) || horizontal_game_over?(find_winner) || 
			fromleft_diagonal_game_over?(find_winner) || fromright_diagonal_game_over?(find_winner)
			if !gm_over && tie
				return :tie
			else
				return gm_over
			end
		end

		def tie
			return board_full?
		end

		def winner
		  winner_name = game_over?(find_winner = true)
		  return nil unless winner_name
		  winner_name
		end

		


		#TODO: Implement a string interpretation of the board.
		def to_s
			s = edge_row + "\n"
			@n_rows.times do |r|
				s << "|"
				@n_cols.times do |c|
					correct_row_index = @n_rows - r -1 
					#flip board updside down for representation
					s << "#{represent_entry(correct_row_index,c)} |"
				end
				s << "\n"
			end
			s << edge_row + "\n"
			s << "  " + (0..@n_cols -1).to_a.join('  ') + "\n"
			return s
		end

		

		def lowest_available_index(col)
			raise ArgumentError if col < 0 || col >= @n_cols
			ind = @n_rows - 1
			return nil unless @positions[ind][col].nil?
			# p @positions[ind][col]
			while @positions[ind][col].nil? && ind >= 0
				ind -= 1
			end
			return ind + 1
		end

		def col_full?(col)
			return true if col < 0 || col >= @n_cols
			lowest_available_index(col).nil?
		end

		private

		def board_full?
			@n_rows.times do |row|
				correct_row_index = @n_rows - row - 1
				@n_cols.times do |column|
					return false if entry(row, column).nil?
				end
			end
			return true
		end

		def setup(r, c)
			arr = Array.new(r)
			r.times do |index|
				arr[index] = Array.new(c)
			end
			arr
		end

		def vertical_game_over?(return_winner = false)
			@n_cols.times do |i|
				(@n_rows - 3).times do |j|
				  break if @positions[j + 3][i].nil?
				  winner_found = (entry(j,i) == entry(j+1, i))	 &&
				  				 (entry(j,i) == entry(j+2, i)) &&
				  				 (entry(j,i) == entry(j+3, i))
				  return true if winner_found && !return_winner
				  return entry(j,i) if winner_found && return_winner
				end
			end
			false
		end

		def horizontal_game_over?(return_winner = false)
			@n_rows.times do |row|
				(@n_cols - 3).times do |col|
				  break if @positions[row][col+3].nil?
				  winner_found =  entry(row, col) == entry(row, col + 1) &&
				  				 entry(row, col) == entry(row, col + 2) &&
				  				 entry(row, col) == entry(row, col + 3)
				  return true if winner_found && !return_winner
				  return entry(row, col) if winner_found && return_winner
				end
			end
			false
		end

		def fromleft_diagonal_game_over?(return_winner = false)
			(@n_rows - 3).times do |i|
			  row = i + 3
			  (@n_cols - 3).times do |j|
			  	col = j
			  	break if entry(row, col).nil?
			  	winner_found = entry(row, col) == entry(row - 1, col + 1) &&
			  				   entry(row, col) == entry(row - 2, col + 2) &&
			  				   entry(row, col) == entry(row - 3, col + 3)
			  	return true if winner_found && !return_winner
			  	return entry(row, col) if winner_found && return_winner
			  end
			end
			false
		end

		def fromright_diagonal_game_over?(return_winner = false)
			  (@n_rows - 3).times do |row|
			    (@n_cols - 3).times do |col|
			  	break if entry(row, col).nil?
			  	winner_found = entry(row, col) == entry(row + 1, col + 1) &&
			  				   entry(row, col) == entry(row + 2, col + 2) &&
			  				   entry(row, col) == entry(row + 3, col + 3)
			  	return true if winner_found && !return_winner
			  	return entry(row, col) if winner_found && return_winner
			  end
			end
			false
		end

		def edge_row
			"-" * (@n_cols * 3 + 1)
		end

		def represent_entry(i,j)
			ent = entry(i,j)
			case ent
			when nil
				return " "
			when :player_1
				return @@p1_representation #white full disc
			when :player_2
				return @@p2_representation #empty disc

			else
				return " "
			end
		end


	end


end