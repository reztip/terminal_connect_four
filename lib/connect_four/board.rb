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