# class Player::Computer < Player
#   def move(board)
#     if !board.taken?('5')
#       '5'
#     else
#       best_move(board) + 1
#     end
#   end
#   def best_move(board)
#     win(board) || block(board) || corner(board) || random
#   end
#   def corner(board)
#     [0,2,6,8].detect{|cell| !board.taken?(cell+1)}
#   end
#   def complete_combo?(board, token)
#     Game::WIN_COMBINATIONS.detect do |combo|
#       (
#         (board.cells[combo[0]] == token && board.cells[combo[1]] == token) &&
#         !board.taken?(combo[2]+1)
#       ) ||
#       (
#         (board.cells[combo[1]] == token && board.cells[combo[2]] == token) &&
#         !board.taken?(combo[0]+1)
#       ) ||
#       (
#         (board.cells[combo[0]] == token && board.cells[combo[2]] == token) &&
#         !board.taken?(combo[1]+1)
#       )
#     end
#   end
#   def win(board)
#     # puts "...checking for win for #{token} on #{board.cells}"
#     winning_combo = complete_combo?(board, self.token)
#     if winning_combo && winning_combo.count{|index| board.position(index+1) == self.token} == 2
#       puts "...found winning combo #{winning_combo}"
#       winning_combo.detect{|index| !board.taken?(index+1)}
#     end
#   end
#   def block(board)
#     # puts "...checking for block for #{token} on #{board.cells}"
#     blocking_combo = complete_combo?(board, self.opponent_token)
#     if blocking_combo && blocking_combo.count{|index| board.position(index+1) == self.opponent_token} == 2
#       puts "...found blocking combo #{blocking_combo}"
#       blocking_combo.detect{|index| !board.taken?(index+1)}
#     end
#   end
#   def opponent_token
#     self.token == "X" ? "O" : "X"
#   end
#   def random
#     (0..8).to_a.sample
#   end
# end

require 'pry'
module Players
  class Computer < Player
    WIN_COMBINATIONS = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [2,4,6]]
    def move(board)
        opponent_token = ""
        if self.token == 'X'
            opponent_token = 'O'
        else
            opponent_token = 'X'
        end
    	move_to_win = two_in_a_row?(board)
        move_to_block = opponent_two_in_a_row?(board)
    	if move_to_win
    		move_to_win
        elsif move_to_block
            move_to_block
        # elsif forkable?
        #     create fork
        # elsif opponent_fork?
        #     block fork
        # If it's free, play the middle
        elsif board.cells[4] == ' '
            5
        # if the opponent's in the corner, play opposite corner when possible
        elsif board.cells[0] == opponent_token && board.cells[8] == ' '
            9
        elsif board.cells[2] == opponent_token && board.cells[6] == ' '
            7
        elsif board.cells[6] == opponent_token && board.cells[2] == ' '
            3
        elsif board.cells[8] == opponent_token && board.cells[0] == ' '
            1
        # If there's an empty corner, play it
        elsif board.cells[0] == ' '
            1
        elsif board.cells[2] == ' '
            3
        elsif board.cells[6] == ' '
            7
        elsif board.cells[8] == ' '
            9
        # LAST RESORT: Plays an empty side
        elsif board.cells[1] == ' '
            2
        elsif board.cells[3] == ' '
            4
        elsif board.cells[5] == ' '
            6
        elsif board.cells[7] == ' '
            8
        # the 'catch-all' - Matheas
        else
            Random.rand(1..9)
    	end
    end
    def opponent_two_in_a_row?(board)
        move = false
        WIN_COMBINATIONS.each do |win_combination|
            num_opponent = win_combination.select do |index|
                board.cells[index] != self.token && board.cells[index] != ' '
            end.size
            if num_opponent == 2
                win_combination.each do |index|
                    if board.cells[index] == ' '
                        move = index + 1
                    end
                end
            end
        end
        move
    end
    def two_in_a_row?(board)
        move = false
        WIN_COMBINATIONS.each do |win_combination|
            num_self = win_combination.select do |index|
                board.cells[index] == self.token
            end.size
            if num_self == 2
                win_combination.each do |index|
                    if board.cells[index] == ' '
                        move = index + 1
                    end
                end
            end
        end
        move
    end
  end
end 
