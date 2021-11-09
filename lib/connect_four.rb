# /lib/connect_four.rb

# board Class

# player Class
# initialise values (@order, @name, @token, @board)
# provide input for player 1


class Player
  attr_reader :token

  def initialize(order, name)
    @order = order
    @name = name
    @token = determine_token(order)
  end

  def determine_token(order)
    if order == 1 
      'x'
    elsif order == 2
      'o'
    else
      order.to_i
    end
  end
end

class Board
  attr_reader :game_squares

  def initialize
    @turn = 0
    @players = []
    @game_over = false
    @columns = 7
    @rows = 6
    @game_squares = create_game_squares
  end

  def create_game_squares
    board = []
    row = []
    @columns.times { row << "_"}
    @rows.times { board << Array.new(row) }
    board
    # NEED TO WRITE TEST FOR THIS METHOD
  end

  def add_players(player_one, player_two)
    @players << player_one
    @players << player_two
  end


  def print_board
    print_top_margin
    print_squares
    print_column_numbers
  end

  def print_top_margin
    @columns.times { print " _" }
    puts
  end

  def print_squares
    @game_squares.each do |row|
      row.each do |square|
        print "|"
        print square
      end
      print "|"
      puts
    end
  end

  def print_column_numbers
    i = 1
    @columns.times do
      print "|#{i}"
      i += 1
      print "|" if i == @columns + 1
    end
    puts
  end

  def game_turn
    new_turn
    current_player = determine_player
    input = get_turn_input
    place_token(input, current_player)
    # Update the gameboard to print the relevant players token on the column matched to input
    # Check for win condition
  end

  def new_turn
    @turn += 1
    puts "Turn #{@turn}"
    print_board
  end

  def determine_player
    @turn.odd? ? @players[0] : @players[1]
  end

  def get_turn_input
    puts "Please enter the column where you would like to place your token."
    input = ""
    loop do
      input = gets.chomp.to_i
      return input if valid_turn(input)
      puts "Incorrect input. Please enter a number between 1 and #{@columns}."
    end
  end

  def valid_turn(input)
    valid_range = (1..@columns)
    return unless input.is_a?(Numeric) && valid_range.include?(input)
    true
  end

  def place_token(input, current_player)
    input_row = 1
    # loop do
    #   return if @game_squares[@rows - input_row][input.to_i - 1] == '_'
    # 
    #   input_row += 1
    # end
    @game_squares[@rows - input_row][input.to_i - 1] = current_player.token
  end
end

  new_game = Board.new
  
 # new_game.draw_board

 # new_game.create_game_squares


 # new_game.print_board

 # new_game.place_token(1, 2)


  
 # new_game.get_turn_input