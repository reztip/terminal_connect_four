module ConnectFour

	class Board

		attr_reader :n_rows, :n_cols, :positions

		def initialize(row = 6, col = 7)
			raise ArgumentError if (row < 4 || col < 4)
			@n_rows = row
			@n_cols = col
			@positions = setup(row, col)
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

		def game_over?
			vertical_game_over? || horizontal_game_over? || fromleft_diagonal_game_over? || fromright_diagonal_game_over?
		end

		def vertical_game_over?
			@n_cols.times do |i|
				(@n_rows - 3).times do |j|
				  break if @positions[j + 3][i].nil?
				  return true if (entry(j,i) == entry(j+1, i))	 &&
				  				 (entry(j,i) == entry(j+2, i)) &&
				  				 (entry(j,i) == entry(j+3, i))
				end
			end
			false
		end

		def horizontal_game_over?
			@n_rows.times do |row|
				(@n_cols - 3).times do |col|
				  break if @positions[row][col+3].nil?
				  return true if entry(row, col) == entry(row, col + 1) &&
				  				 entry(row, col) == entry(row, col + 2) &&
				  				 entry(row, col) == entry(row, col + 3)
				end
			end
			false
		end

		def fromleft_diagonal_game_over?
			(@n_rows - 3).times do |i|
			  row = i + 3
			  (@n_cols - 3).times do |j|
			  	col = j
			  	break if entry(row, col).nil?
			  	return true if entry(row, col) == entry(row - 1, col + 1) &&
			  				   entry(row, col) == entry(row - 2, col + 2) &&
			  				   entry(row, col) == entry(row - 3, col + 3)
			  end
			end
			false
		end

		def fromright_diagonal_game_over?
			  (@n_rows - 3).times do |row|
			    (@n_cols - 3).times do |col|
			  	break if entry(row, col).nil?
			  	return true if entry(row, col) == entry(row + 1, col + 1) &&
			  				   entry(row, col) == entry(row + 2, col + 2) &&
			  				   entry(row, col) == entry(row + 3, col + 3)
			  end
			end
			false
		end


		#TODO: Implement a string interpretation of the board.
		def to_s
			s = edge_row



			s+= edge_row
			s
		end

		def edge_row
			"-" * @n_cols
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

		private
		def setup(r, c)
			arr = Array.new(r)
			r.times do |index|
				arr[index] = Array.new(c)
			end
			arr
		end


	end


end