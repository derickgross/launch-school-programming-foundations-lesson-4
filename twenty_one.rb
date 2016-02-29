deck = []
player_cards = []
dealer_cards = []
player_name = ""

def prompt(message)
  puts "-> #{message}"
end

def set_empty_hands(player_cards, dealer_cards)
  player_cards.clear
  dealer_cards.clear
end

def initialize_deck
  suits = ["Spades", "Clubs", "Hearts", "Diamonds"]
  ranks = *(2..10).map(&:to_s) + ["J", "Q", "K", "A"]

  suits.product(ranks).shuffle!
end

def deal_card(player_cards, deck)
  player_cards << deck.pop
end

def deal_initial_hands(player_cards, dealer_cards, deck)
  2.times do
    deal_card(player_cards, deck)
    deal_card(dealer_cards, deck)
  end
end

def show_cards(cards)
  card_strings = []
  cards.each do |card|
    card_strings << card_name(card)
  end
  card_strings.join(", ")
end

def card_name(card)
  "#{card[1]} of #{card[0]}"
end

def hand_value(hand)
  value = 0
  aces = 0
  hand.each do |card|
    if card[1] == "A"
      aces += 1
    end
  end

  hand.each do |card|
    value += card_value(card)
  end
  while (value > 21) && (aces > 0)
    value -= 10
    aces -= 1
  end
  value
end

def display_cards(player_name, player_cards)
  prompt "#{player_name}'s cards are: #{show_cards(player_cards)}."
end

def display_hand_value(player_name, player_cards)
  prompt "#{player_name}'s hand value is #{hand_value(player_cards)}."
end

def display_dealer_cards_and_hand_value(dealer_cards)
  prompt "Dealer's cards are: #{show_cards(dealer_cards)}."
  prompt "Dealer's hand value is #{hand_value(dealer_cards)}."
end

def card_value(card)
  rank = card[1]
  value = 0
  case
  when ["J", "Q", "K"].include?(rank)
    value = 10
  when rank == "A"
    value = 11
  when *(2..10).include?(rank.to_i)
    value = rank.to_i
  end
  value
end

def bust?(hand)
  hand_value(hand) > 21
end

def twenty_one?(hand)
  hand_value(hand) == 21
end

def player_hits?
  result = nil
  loop do
    prompt "Type 'hit' to hit or 'stay' to stay:"
    player_action = gets.chomp

    if player_action == 'hit'
      result = true
      break
    elsif player_action == 'stay'
      result = false
      break
    else
      prompt "Invalid choice."
      next
    end
  end
  result
end

def player_bust(player_name, player_cards)
  display_cards(player_name, player_cards)
  prompt "#{player_name} busts with a hand value of #{hand_value(player_cards)}."
end

def dealer_hits(dealer_cards, player_cards, deck)
  while (hand_value(dealer_cards) < 17) || (hand_value(dealer_cards) < hand_value(player_cards))
    display_dealer_cards_and_hand_value(dealer_cards)
    prompt "Dealer hits."
    deal_card(dealer_cards, deck)
    prompt "Dealer received the #{card_name(dealer_cards.last)}"
  end
end

def dealer_result(dealer_cards, player_cards, player_name)
  if hand_value(dealer_cards) > 21
    display_dealer_cards_and_hand_value(dealer_cards)
    prompt "Dealer busts.  #{player_name} wins!"
  elsif (hand_value(dealer_cards) <= 21) && (hand_value(dealer_cards) >= hand_value(player_cards))
    display_dealer_cards_and_hand_value(dealer_cards)
    display_hand_value(player_name, player_cards)
    prompt "Dealer wins."
  end
end

def player_turn(player_name, player_action, player_cards, deck)
  loop do
    deal_card(player_cards, deck)

    break if twenty_one?(player_cards) || bust?(player_cards)

    display_cards(player_name, player_cards)
    display_hand_value(player_name, player_cards)

    break unless player_hits?
  end
end

def dealer_turn(dealer_cards, player_cards, deck, player_name)
  dealer_hits(dealer_cards, player_cards, deck)

  dealer_result(dealer_cards, player_cards, player_name)
end

def play_again?
  result = nil
  loop do
    prompt "Would you like to play again?  Type 'yes' or 'no'."

    answer = gets.chomp
    if answer.downcase == 'yes'
      result = true
      break
    elsif answer.downcase == 'no'
      result = false
      break
    else
      prompt "Invalid choice."
      next
    end
  end
  result
end

prompt "Welcome to Twenty One!"

prompt "What is the player's name?"
player_name = gets.chomp

loop do
  set_empty_hands(player_cards, dealer_cards)
  deck = initialize_deck
  deal_initial_hands(player_cards, dealer_cards, deck)

  display_cards(player_name, player_cards)
  display_hand_value(player_name, player_cards)

  if twenty_one?(player_cards)
    prompt "#{player_name} wins!"
    play_again? ? next : (prompt "Thank you for playing Twenty One!"; break)
  end

  prompt "You can only see one of the computer's cards: #{card_name(dealer_cards.first)}."
  prompt "#{player_name}, it's your turn.  Type 'hit' to hit or 'stay' to stay:"

  player_action = gets.chomp

  player_turn(player_name, player_action, player_cards, deck) if player_action == "hit"

  if bust?(player_cards)
    player_bust(player_name, player_cards)
    play_again? ? next : (prompt "Thank you for playing Twenty One!"; break)
  elsif twenty_one?(player_cards)
    display_hand_value(player_name, player_cards)
    prompt "#{player_name} wins!"
  else
    dealer_turn(dealer_cards, player_cards, deck, player_name)
  end

  play_again? ? next : (prompt "Thank you for playing Twenty One!"; break)
end
