# class Game
#   attr_accessor :board, :player_1, :player_2
#   WIN_COMBINATIONS = [
#     [0,1,2],
#     [3,4,5],
#     [6,7,8],
#     [0,3,6],
#     [1,4,7],
#     [2,5,8],
#     [0,4,8],
#     [6,4,2]
#   ]
#   def initialize(player_1 = Player::Human.new("X"), player_2 = Player::Human.new("O"), board = Board.new)
#     @board = board
#     @player_1 = player_1
#     @player_2 = player_2
#   end
#   def over?
#     won? || draw?
#   end
#   def current_player
#     @board.turn_count % 2 == 0 ? @player_1 : @player_2
#   end
#   def winner
#     if winning_combo = won?
#       @winner = @board.cells[winning_combo.first]
#     end
#   end
#   def turn
#     player = current_player
#     current_move = player.move(@board)
#     if !@board.valid_move?(current_move)
#       turn
#     else
#       puts "Turn: #{@board.turn_count+1}\n"
#       @board.display
#       @board.update(current_move, player)
#       puts "#{player.token} moved #{current_move}"
#       @board.display
#       puts "\n\n"
#     end
#   end
#   def play
#     while !over?
#       turn
#     end
#     if won?
#       puts "Congratulations #{winner}!"
#     elsif draw?
#       puts "Cats Game!"
#     end
#   end
#   def won?
#     WIN_COMBINATIONS.detect do |combo|
#       @board.cells[combo[0]] == @board.cells[combo[1]] &&
#       @board.cells[combo[1]] == @board.cells[combo[2]] &&
#       @board.taken?(combo[0]+1)
#     end
#   end
#   def draw?
#     @board.full? && !won?
#   end
# end

class Game
  attr_accessor :board, :player_1, :player_2
  WIN_COMBINATIONS = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [2,4,6]]
    def initialize(player_1=nil, player_2=nil, board=nil)
      @player_1 = player_1
      @player_2 = player_2
      @board = board
      @player_1 = Players::Human.new('X') if @player_1 == nil
      @player_2 = Players::Human.new('O') if @player_2 == nil
      @board = Board.new if @board == nil
    end
    def current_player
      #binding.pry
      board_of_X = @board.cells.select do |cell| cell == 'X' end
      board_of_O = @board.cells.select do |cell| cell == 'O' end

      num_X = board_of_X.length
      num_O = board_of_O.length
      if num_X == num_O
        player_1
      else
        player_2
      end
    end
    def over?
      won? || draw?
    end
    def won?
   WIN_COMBINATIONS.each do |win_combo|
     if (board.cells[win_combo[0]] == "X" && board.cells[win_combo[1]] == "X" && board.cells[win_combo[2]] == "X") ||
        (board.cells[win_combo[0]] == "O" && board.cells[win_combo[1]] == "O" && board.cells[win_combo[2]] == "O")
        return win_combo
     end
   end
   return false
 end
    def draw?
      !won? && @board.full?
    end
    def winner
      if won?
        the_winner = ''
         WIN_COMBINATIONS.each do |combination|
          if (combination.all? {|spot| @board.cells[spot] == 'X'} ||
              combination.all? {|spot| @board.cells[spot] == 'O'} )
            the_winner = @board.cells[combination[0]]
          end
        end
        the_winner
      else
        nil
      end
    end
    def turn
      player = current_player
      move_valid = false
      while !move_valid
        move = player.move(@board).to_i
        move_valid = @board.valid_move?(move)
      end
      token = player.token
      #binding.pry
      @board.cells[move - 1] = token
      #binding.pry
    end
    def play
      @board.display
      while !over?
        turn
        @board.display
        # binding.pry
      end
      if won?
        puts "Congratulations #{winner}!"
      else
        puts "Cat's Game!"
      end
    end
end
