require 'spec_helper'
module ConnectFour
	describe Board do |l|
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
	end
	end
end