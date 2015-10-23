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
			raise ArgumentError if (r < 0 || r >= @n_rows || c < 0 || c >= @n_cols)
			@positions[r][c]
		end



		def to_s
			s = edge_row



			s+= edge_row
			s
		end

		private
		def edge_row
			"-" * @n_cols
		end

		def lowest_available_index(col)
			raise ArgumentError if col < 0 || col >= @n_cols
			ind = @n_rows - 1
			return nil unless @positions[ind][col].nil? 
			while (@positions[ind][col]).nil?
				ind -= 1
			end

			return (ind < 0 ? 0 : ind)
		end

		def setup(r, c)
			arr = Array.new(r)
			r.times do |index|
				arr[index] = Array.new(c)
			end
			arr
		end


	end


end