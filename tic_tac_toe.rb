require "pry"

current_player_is_player = true

player_wins = 0
computer_wins = 0

board_values = { 1 => " ", 2 => " ", 3 => " ", 4 => " ", 5 => " ", 6 => " ", 7 => " ", 8 => " ", 9 => " " }

board_references = *(0..9)

def add_player_choice_to_board_values(board_values, choice)
  board_values[choice] = "X"
end

def add_computer_choice_to_board_values(board_values, choice)
  board_values[choice] = "O"
end

def display_board(board_values)
  board = <<-BOARD
 #{board_values[1]} | #{board_values[2]} | #{board_values[3]} 
---+---+---
 #{board_values[4]} | #{board_values[5]} | #{board_values[6]} 
---+---+---
 #{board_values[7]} | #{board_values[8]} | #{board_values[9]} 
  BOARD
  puts board
end

def prompt(message)
  puts "-> #{message}"
end

# rubocop:disable Metrics/AbcSize
def winner(board_values)
  winning_combinations = [
    [board_values[1], board_values[2], board_values[3]],
    [board_values[4], board_values[5], board_values[6]],
    [board_values[7], board_values[8], board_values[9]],
    [board_values[1], board_values[4], board_values[7]],
    [board_values[2], board_values[5], board_values[9]],
    [board_values[3], board_values[6], board_values[9]],
    [board_values[1], board_values[5], board_values[9]],
    [board_values[3], board_values[5], board_values[7]]
  ]

  result = nil

  winning_combinations.each do |combo|
    if combo.uniq == ["X"]
      result = "Player"
      break
    elsif combo.uniq == ["O"]
      result = "Computer"
      break
    else
      result = nil
    end
  end
  result
end
# rubocop:enable Metrics/AbcSize

def display_win_totals(player_wins, computer_wins)
  prompt "Player wins: #{player_wins}"
  prompt "Computer wins: #{computer_wins}"
end

def empty_square?(board_values, square)
  board_values[square] == " "
end

def player_chooses_square(board_values)
  choice = ""

  loop do
    prompt "Please choose an empty square."
    choice = gets.chomp.to_i

    break unless !empty_square?(board_values, choice)
    prompt "Your choice is invalid.  Please choose an empty square."
  end

  add_player_choice_to_board_values(board_values, choice)
end

def computer_chooses_square(board_values)
  winning_combinations = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    [1, 4, 7],
    [2, 5, 8],
    [3, 6, 9],
    [1, 5, 9],
    [3, 5, 7]
  ]

  square = "test"
  o_win = nil
  x_block = nil

  winning_combinations.each do |combo|
    combo_values = [board_values[combo[0]], board_values[combo[1]], board_values[combo[2]]]
    if (combo_values.count("O") == 2) && (combo_values.count(" ") == 1)
      o_win = combo[combo_values.index(" ")]
    elsif (combo_values.count("X") == 2) && (combo_values.count(" ") == 1)
      x_block = combo[combo_values.index(" ")]
    else
      if board_values[5] == " "
        square = 5
      else
        square = board_values.select { |_key, value| value == " " }.keys.sample
      end
    end

    if o_win
      square = o_win
    elsif x_block
      square = x_block
    end
    square
  end

  add_computer_choice_to_board_values(board_values, square)

  prompt "Computer chose #{square}."
end

def board_full?(board_values)
  !board_values.values.include?(" ")
end

def display_winner(board_values)
  prompt "#{winner(board_values)} wins!"
end

def display_tie
  prompt "Game ends in a tie."
end

def current_player_chooses_square(current_player_is_player, board_values)
  current_player_is_player ? player_chooses_square(board_values) : computer_chooses_square(board_values)
end

prompt "Welcome to Tic Tac Toe!"
prompt "Player's token is X, computer's token is O."
sleep 1
prompt "First to win 5 games wins the match."
sleep 1
prompt "When choosing a square, enter the corresponding number from the board below:"
display_board(board_references)

puts ""

loop do
  loop do
    prompt "Do you want to make the first move?"
    answer = gets.chomp

    current_player_is_player = answer.downcase.start_with?('y')

    board_values = { 1 => " ", 2 => " ", 3 => " ", 4 => " ", 5 => " ", 6 => " ", 7 => " ", 8 => " ", 9 => " " }

    display_board(board_values)

    loop do
      sleep 0.5
      puts ""
      current_player_chooses_square(current_player_is_player, board_values)
      system "clear" if current_player_is_player == true
      display_board(board_values)
      current_player_is_player = !current_player_is_player
      if !!winner(board_values)
        display_winner(board_values)
        if winner(board_values) == "Player"
          player_wins += 1
          display_win_totals(player_wins, computer_wins)
        elsif winner(board_values) == "Computer"
          computer_wins += 1
          display_win_totals(player_wins, computer_wins)
        end
        break
      end
      if board_full?(board_values)
        display_tie
        break
      end
    end

    if player_wins == 5
      prompt "Player wins the match!"
      break
    elsif computer_wins == 5
      prompt "Computer wins the match."
      break
    end
  end

  prompt("Play again?")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thank you for playing Tic Tac Toe!  Goodbye!"
