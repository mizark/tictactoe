class BoardsController < ApplicationController

	def new
		@board = Board.new
		@board.save
	end

	def make_move
		@board = Board.find(params[:id])

		#save the player move to spot
		@board.spots[params[:space].to_i] = 'X'
		@board.save
		
		#evaluate board to get breakdown of spots and see if there's a winner
		player_moves, computer_moves, available_spots = evaluate_board(@board)
		@winner, @winning_spots = find_winner(Board.winning_combos, player_moves, computer_moves, available_spots)
		
		#computer goes through hierarchy of priorities to make best move if
		# there isn't already a winner
		if @winner.nil?
			# 1. check if computer can make move to win game
			if test(Board.winning_combos, computer_moves, available_spots)

			# 2. check if computer needs to make move to block player from winning
			elsif test(Board.winning_combos, player_moves, available_spots)

			# 3. check if computer can make move to force player to defend instead of creating fork
			elsif diverge_fork(Board.winning_combos, computer_moves, available_spots)
			
			# 4. check if computer can make move to create a fork 
			elsif test(Board.fork_combos, computer_moves, available_spots)

			# 5. check if computer can block player from creating a fork
			elsif test(Board.fork_combos, player_moves, available_spots)
			
			# 6. computer picks center spot if open
			elsif pick_center(available_spots)

			# 7. computer picks opposite corner if player chooses corner spot
			elsif pick_opposite_corner(available_spots, player_moves, Board.opposite_corners)

			# 8. computer picks corner spot if available
			elsif pick_spot(available_spots, Board.corner_spots)

			# 9. computer picks side spot if open
			elsif pick_spot(available_spots, Board.side_spots)
			end

			#evaluate board to check again for any winners or end of game
			player_moves, computer_moves, available_spots = evaluate_board(@board)
			if @winner.nil?
				@winner, @winning_spots = find_winner(Board.winning_combos, player_moves, computer_moves, available_spots)
			end
		end

		@space = params[:space]

		#output moves or final result of game through ajax
		respond_to do |format|
			if @winner.nil?
				format.js
			
			#rendered when game is over
			else
				format.js { render 'final.js.erb'}
			end
		end
	end

	#methods used from above
	private

		#see where the player and computer have moves as well as open spots
		def evaluate_board(board)
			player_moves = Array.new
			computer_moves = Array.new
			available_spots = Array.new

			board.spots.split(//).each_with_index do |c,index|
				player_moves.push(index) if c == 'X'
				computer_moves.push(index) if c == 'O'
				available_spots.push(index) if c == ' '
			end

			return player_moves, computer_moves, available_spots
		end

		#see if either the player or computer has hit a winning combo
		def find_winner(winning_combos, player_moves, computer_moves, available_spots)
			winning_combos.each do |combo|
				return 'You win!', combo if combo & player_moves == combo
				return 'Sorry friend, you lost!', combo if combo & computer_moves == combo
			end

			#checks if there are any spots on the board. if not, and winner is nil, game is a draw.
			if available_spots.size == 0
				return 'Tis a draw!', []
			end

			return nil
		end
			
		#make move based on if computer or player moves are set up for win or fork
		def test(combo_array, player_array, available_spots)
			combo_array.each do |combo|
				temp = combo - player_array
				if temp.size == 1 && available_spots.include?(temp[0])
			 		@board.spots[temp[0]] = 'O'
			 		@board.save
			 		@comp_move = temp[0]
			 		return true
			 		break
			 	end
			 end
			 return false
		end

		#computer makes move to force player to defend before they can achieve a fork
		def diverge_fork(winning_combos, computer_moves, available_spots)
			winning_combos.each do |combo|
				temp = combo - computer_moves
				if temp.size == 2 && available_spots.include?(temp[0]) && available_spots.include?(temp[1])
					@board.spots[temp[0]] = 'O'
			 		@board.save
			 		@comp_move = temp[0]
			 		return true
			 		break
			 	end
		 	end
		 	return false
		 end
		
		#computer picks center spot if its open
		def pick_center(available_spots)
			if available_spots.include? 4
		 		@board.spots[4] = 'O'
		 		@board.save
		 		@comp_move = 4
		 		return true
			end
			return false
		end

		#computer picks spot in opposite corner if player chooose corner
		def pick_opposite_corner(available_spots, player_moves, opposite_corners)
			available_spots.each do |s|
				if player_moves.include? opposite_corners[s]
			 		@board.spots[s] = 'O'
			 		@board.save
			 		@comp_move = s
			 		return true
			 		break
			 	end
			end
			return false
		end

		#computer picks a spot (side spot if corner spot is unavailable)
		def pick_spot(available_spots, spots)
			available_spots.each do |s|
			 	if spots.include? s
			 		@board.spots[s] = 'O'
			 		@board.save
			 		@comp_move = s
			 		return true
			 		break
			 	end
			end
		 	return false
		end

end
