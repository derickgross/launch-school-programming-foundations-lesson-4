require "pry"

board_values = { one: " ", two: " ", three: " ", four: " ", five: " ", six: " ", seven: " ", eight: " ", nine: " " }

board_reference = { one: "1", two: "2", three: "3", four: "4", five: "5", six: "6", seven: "7", eight: "8", nine: "9" }

def add_player_choice_to_board_values(board_values, choice)
  board_values[choice] = "X"
end

def add_computer_choice_to_board_values(board_values, choice)
  board_values[choice] = "O"
end

def display_board(board_values)
  board = " #{board_values[:one]} | #{board_values[:two]} | #{board_values[:three]} 
---+---+---
 #{board_values[:four]} | #{board_values[:five]} | #{board_values[:six]} 
---+---+---
 #{board_values[:seven]} | #{board_values[:eight]} | #{board_values[:nine]} "
  puts board
end

def prompt(message)
  puts "-> #{message}"
end

def winner?(board_values)
  winning_combinations = { "123" => [board_values[:one], board_values[:two], board_values[:three]], "456" => [board_values[:four], board_values[:five], board_values[:six]], "789" => [board_values[:seven], board_values[:eight], board_values[:nine]], "147" => [board_values[:one], board_values[:four], board_values[:seven]], "258" => [board_values[:two], board_values[:five], board_values[:eight]], "369" => [board_values[:three], board_values[:six], board_values[:nine]], "159" => [board_values[:one], board_values[:five], board_values[:nine]], "357" => [board_values[:three], board_values[:five], board_values[:seven]] }

  result = nil

  winning_combinations.values.each do |combo|
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

def empty_square?(board_values, square)
  board_values[square] == " "
end

def choice_translator(choice)
  square = ""

  case choice
  when "1"
    square = :one
  when "2"
    square = :two
  when "3"
    square = :three
  when "4"
    square = :four
  when "5"
    square = :five
  when "6"
    square = :six
  when "7"
    square = :seven
  when "8"
    square = :eight
  when "9"
    square = :nine
  end
  square
end

def player_chooses_square(board_values)
  choice = ""

  loop do
    prompt "Please choose an empty square."
    choice = gets.chomp

    if !empty_square?(board_values, choice_translator(choice))
      prompt "Your choice is invalid.  Please choose an empty square."
    else
      break
    end
  end

  add_player_choice_to_board_values(board_values, choice_translator(choice))
end

def computer_chooses_square(board_values)
  square = board_values.select { |_key, value| value == " " }.keys.sample.to_sym
  add_computer_choice_to_board_values(board_values, square)

  prompt "Computer chose #{square}."
end

def board_full?(board_values)
  !board_values.values.include?(" ")
end

def display_winner(board_values)
  prompt "#{winner?(board_values)} wins!"
end

def display_tie
  prompt "Game ends in a tie."
end

prompt "Welcome to Tic Tac Toe!"
prompt "Player's token is X, computer's token is O."
prompt "When choosing a square, enter the corresponding number from the board below:"
display_board(board_reference)

puts ""

loop do
  board_values = { one: " ", two: " ", three: " ", four: " ", five: " ", six: " ", seven: " ", eight: " ", nine: " " }

  loop do
    display_board(board_values)
    player_chooses_square(board_values)
    display_board(board_values)
    if !!winner?(board_values)
      display_winner(board_values)
      break
    end
    if board_full?(board_values)
      display_tie
      break
    end
    sleep 0.5
    computer_chooses_square(board_values)
    if !!winner?(board_values)
      display_winner(board_values)
      break
    end
    if board_full?(board_values)
      display_tie
      break
    end
  end

  prompt("Play again?")
  answer = gets.chomp

  break unless answer.downcase.start_with?('y')
end

prompt "Thank you for playing Tic Tac Toe!  Goodbye!"
