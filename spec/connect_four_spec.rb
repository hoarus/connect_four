# frozen_string_literal: true
# /spec/connect_four_spec.rb

require_relative '../lib/connect_four.rb'

describe Player do
  # Player class is used to keep track of each player in Connect Four and their token
  let(:player_name) { String.new('Sam') }
  subject(:new_player) { described_class.new(1, player_name) }

  describe '#determine_token' do
    it 'Assigns the x token when Order 1' do
      expect(new_player.determine_token(1)).to eq('x')
    end
    it 'Assigns the o token when Order 2' do
      expect(new_player.determine_token(2)).to eq('o')
    end
    it 'Assigns 3 as a token when Order 3' do
      expect(new_player.determine_token(3)).to eq(3)
    end
  end
end 

describe Board do
  subject(:new_game) { described_class.new() }

  describe '#add_players' do
    context 'When there are two players' do
      let(:player_one) { instance_double(Player) }
      let(:player_two) { instance_double(Player) }

      it 'The first player is added' do
        players = new_game.instance_variable_get(:@players)
        new_game.add_players(player_one, player_two)
        expect(players[0]).to be(player_one)
      end

      it 'The second player is added' do
        players = new_game.instance_variable_get(:@players)
        new_game.add_players(player_one, player_two)
        expect(players[1]).to be(player_two)
      end
    end
  end
  
  describe '#print_board' do
    # This is a print only method, so tests are not required
  end

  describe '#new_turn' do
    subject(:new_game) { described_class.new() }

    before do
      allow(new_game).to receive(:puts)
      allow(new_game).to receive(:print)
    end

    context 'When turn is 0' do
      before do 
        new_game.instance_variable_set(:@turn, 0)
      end
      it 'Increases to 1' do
        new_game.new_turn
        turn = new_game.instance_variable_get(:@turn)
        expect(turn).to be(1)
      end
    end

    context 'When turn is 1' do
      before do 
        new_game.instance_variable_set(:@turn, 1)
      end

      it 'Increases to 2' do
        new_game.new_turn
        turn = new_game.instance_variable_get(:@turn)
        expect(turn).to be(2)
      end
    end
  end

  describe '#determine_player' do
    subject(:new_game) { described_class.new() }
    context 'When turn is odd' do
      before do
        new_game.instance_variable_set(:@turn, 1)
      end
      it 'Player 1' do
        players = new_game.instance_variable_set(:@players, [1, 2])
        expect(new_game.determine_player).to eq(players[0])
      end
    end
    context 'When turn is even' do
      before do
        new_game.instance_variable_set(:@turn, 22)
      end
      it 'Player 2' do
        players = new_game.instance_variable_set(:@players, [1, 2])
        expect(new_game.determine_player).to eq(players[1])
      end
    end
  end

  describe '#valid_turn' do
    subject(:new_game) { described_class.new() }

    context 'When input is a string' do
      subject(:input) { String.new('Test') }
      it 'returns nil' do
        expect(new_game.valid_turn(input)).to be(nil)
      end
    end

    context 'When input is a number outside of column range' do
      subject(:input) { 10 }
      it 'returns nil' do
        expect(new_game.valid_turn(input)).to be(nil)
      end
    end

    context 'When input is a number inside column range' do
      subject(:input) { 1 }
      it 'returns true' do
        expect(new_game.valid_turn(input)).to be(true)
      end
    end

    context 'When input is a number equal to columns' do
      subject(:input) { 6 }
      before do
        new_game.instance_variable_set(:@columns, 6)
      end
      it 'returns true' do
        expect(new_game.valid_turn(input)).to be(true)
      end
    end


  end
  describe '#get_turn_input' do
    subject(:new_game) { described_class.new() }
    subject(:columns) { new_game.instance_variable_get(:@columns) }

    context 'When valid_turn returns true' do
      before do
        allow(new_game).to receive(:gets).and_return('')
        # Note that the gets must not return nil so that the chained methods :chomp and :to_i work
        allow(new_game).to receive(:valid_turn).and_return(true)
      end
      it 'Does not puts error message' do
        error_message = "Incorrect input. Please input a number between 1 and #{columns}." 
        expect(new_game).not_to receive(:puts).with(error_message)
        new_game.get_turn_input
      end
    end

    context 'When valid_turn returns false once, then true' do
      before do
        allow(new_game).to receive(:puts)
        allow(new_game).to receive(:gets).and_return('')
        # Note that the gets must not return nil so that the chained methods :chomp and :to_i work
        allow(new_game).to receive(:valid_turn).and_return(nil, true)
      end
      it 'completes loop and displays error message once' do
        error_message = "Incorrect input. Please enter a number between 1 and #{columns}." 
        expect(new_game).to receive(:puts).with(error_message)
        new_game.get_turn_input
      end
    end 
    context 'When valid_turn returns false three times, then true' do
      before do
        allow(new_game).to receive(:valid_turn).and_return(nil, false, nil, true)
        allow(new_game).to receive(:puts)
        allow(new_game).to receive(:gets).and_return('')
        # Note that the gets must not return nil so that the chained methods :chomp and :to_i work
      end
      it 'completes loop and displays error message three times' do
        error_message = "Incorrect input. Please enter a number between 1 and #{columns}." 
        expect(new_game).to receive(:puts).with(error_message).exactly(3).times
        new_game.get_turn_input
      end
    end 
  end

  describe '#place_token' do
    subject(:new_game) { described_class.new() }
    let(:player_one) { instance_double(Player, token: 'x') }
    context 'When first row is empty' do
      it 'Updates the 1st value in the last row when given 1' do
        input = '1'
        new_game.place_token(input, player_one)
        game_board = new_game.instance_variable_get(:@game_squares)
        expect(game_board[5][0]).to eq('x')
      end
      it 'Updates the 3rd value in the last row when given 3' do
        input = '3'
        new_game.place_token(input, player_one)
        game_board = new_game.instance_variable_get(:@game_squares)
        expect(game_board[5][2]).to eq('x')
      end
      it 'Updates the 7th value in the last row when given 7' do
        input = '7'
        new_game.place_token(input, player_one)
        game_board = new_game.instance_variable_get(:@game_squares)
        expect(game_board[5][6]).to eq('x')
      end
    end
    context 'When first row is full' do
      before do
        game_squares =  new_game.instance_variable_get(:@game_squares)
        full_row = ['x', 'x', 'x', 'x', 'x', 'x', 'x']
        game_squares_full = game_squares.push(full_row)
        new_game.instance_variable_set(:@game_squares, game_squares_full)
      end
      it 'Updates the 1st value in the 2nd last row when given 1' do
        input = '1'
        new_game.place_token(input, player_one)
        game_board = new_game.instance_variable_get(:@game_squares)
        expect(game_board[4][0]).to eq('x')
      end
    end
  end
end