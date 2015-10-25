require 'spec_helper'
module ConnectFour
	describe Board do
		describe "#initialize" do
		  it "initializes to 6 rows by 7 columns by default" do
	  	    board = Board.new
	  	    expect(board.n_rows).to eq 6
	  	    expect(board.n_cols).to eq 7
		  end

		  it "initializes if given big enough rows, cols" do
		  	board = Board.new(8,10)
		  	expect(board.n_rows).to eq 8
		  	expect(board.n_cols).to eq 10
		  end

		  it "throws an exception if nrows < 4" do
		  	expect {board = Board.new(3,5)}.to raise_error(ArgumentError)
		  end

		  it "throws an exception if ncols < 4" do
		    expect {board = Board.new(5,3)}.to raise_error(ArgumentError)
		  end

		end

		describe "#positions" do
		  before(:each) do
		  	@board = Board.new
		  end
		  context "the board was just initialized" do
		    it "has all nil (empty) entries" do
		    	expect(@board.positions.flatten).to satisfy { |arr| arr.all? &:nil? }
		    end
		  end
		#NOTE: HERE ENTRIES GROW FROM THE BOTTOM/LEFT UP.  
		describe "#entry" do
			before(:each) {@board = Board.new}

			it "throws ArgumentError for invalid entries" do
				expect {@board.entry(-1, 3)}.to raise_error(ArgumentError)
				expect { @board.entry(3, -1) }.to raise_error(ArgumentError)
				expect { @board.entry(@board.n_rows, 1) }.to raise_error(ArgumentError)
				expect { @board.entry(1, @board.n_cols) }.to raise_error(ArgumentError)

			end

			context "returns the entry in positions r,c" do
				it "returns nil for an unplayed position" do
					expect(@board.entry(2,3)).to be_nil
				end
			end
		end

		describe "#lowest_available_index" do
			let(:board) {Board.new}

			it "notes that bottom row is valid on new board" do
			  board.n_cols.times do |i|
		  		expect(board.lowest_available_index(i)).to eq 0
			  end
			end

			it "notes the correct rrow after moves have been made" do
				positions = board.positions
				# p positions
				col = 2
				positions[0][col] = :player_1 #hacky attempt
				positions[1][col] = :player_2
				expect(board.lowest_available_index(col)).to eq 2
			end

			it "raises ArgumentError if column out of bounds" do
				expect{board.lowest_available_index(-1)}.to raise_error ArgumentError
				expect{board.lowest_available_index(board.n_cols)}.to raise_error ArgumentError
			end
		end

		describe "#make_move" do
		  let(:board) {Board.new}
		  let(:column) {2}

		  context "invalid input" do
		  	it "raises Argument error with bad column" do
		  	  expect {board.make_move(:player, -1)}.to raise_error ArgumentError
		  	  expect {board.make_move(:player, board.n_cols)}.to raise_error ArgumentError
		  	end

		  	it "raises ArgumentError if player is nil" do
		  		expect{board.make_move(nil, 1)}.to raise_error ArgumentError
		  	end

		  	it "raises ArgumentError if there are no rows available " do
		  		board.should_receive(:lowest_available_index).with(1).and_return nil
		  		expect{board.make_move(:player, 1)}.to raise_error ArgumentError
		  	end
		  end

		  context "making moves on a new board" do
		  	it "makes a move on a new board" do
		  	  board.make_move(:player_1,column)
		  	  expect(board.entry(0, column)).to eq :player_1
		  	  expect(board.lowest_available_index(column)).to eq 1
		  	end

		  	it "makes several moves on the same column" do
		  		board = Board.new
		  		board.make_move(:player_1, column)
		  		board.make_move(:player_2, column)
		  		board.make_move(:player_1, column)
		  		expect(board.entry(1, column)).to eq :player_2
		  		expect(board.entry(2, column)).to eq :player_1
		  		expect(board.lowest_available_index(column)).to eq 3
		  	end

		  end

		end

		describe "#make_moves" do
		  it "makes a series of moves correctly" do
		  	board = Board.new
		  	board.make_moves(:player_1, 0,1,0,1,2,3,1)
		  	expect(board.lowest_available_index(0)).to eq 2
		  	expect(board.lowest_available_index(1)).to eq 3
		  	expect(board.lowest_available_index(2)).to eq 1
		  	expect(board.lowest_available_index(3)).to eq 1
		  end

		  it "accepts an array of moves" do
		  	board = Board.new
		  	board.make_moves(:player_1, [0,1,0,1,2,3,1])
		  	expect(board.lowest_available_index(0)).to eq 2
		  	expect(board.lowest_available_index(1)).to eq 3
		  	expect(board.lowest_available_index(2)).to eq 1
		  	expect(board.lowest_available_index(3)).to eq 1
		  end
		end

		describe "#game_over?" do
		  before(:each) {@board = Board.new}
		  context "game is not over" do
		    it "returns false for a new game" do
		    	expect(@board.game_over?).to be false
		    end

		    it "returns false for different not-finished game" do
		    	col = 1
		    	@board.make_move(:player_1, col)
		    	@board.make_move(:player_1, col)
		    	@board.make_move(:player_1, col)
		    	expect(@board.game_over?).to be false
		    end
		  end

		  context "game is over" do
		  	it "detects trivial game over" do
		  		col = 1
		  		@board.make_move(:player_1, col)
		  		@board.make_move(:player_1, col)
		  		@board.make_move(:player_1, col)
		  		@board.make_move(:player_1, col)
		  		expect(@board.game_over?).to be true
		  	end

		  	it "detects horizontal game over" do
		  		@board.make_move(:player_1, 0)
		  		@board.make_move(:player_1, 1)
		  		@board.make_move(:player_1, 2)
		  		@board.make_move(:player_1, 3)
		  		expect(@board.game_over?).to be true
		  	end

		  	it "detects a diagonal game over" do
		  		@board.make_move(:player_1, 0)
		  		@board.make_move(:player_2, 1)
		  		@board.make_move(:player_1, 1)
		  		@board.make_move(:player_1, 2)
		  		@board.make_move(:player_2, 2)
		  		@board.make_move(:player_1, 2)
		  		@board.make_move(:player_2, 3)
		  		@board.make_move(:player_2, 3)
		  		@board.make_move(:player_1, 3)
		  		@board.make_move(:player_1, 3)
		  		expect(@board.game_over?).to be true
		  	end
		  end

		end

	end
	end
end