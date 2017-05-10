require_relative 'cards'

class Player
  attr_accessor :name, :money_amount, :cards, :points_amount

  def initialize(*)
    @cards = []
    @money_amount = 100
    @points_amount = 0
  end

  def take_card(*cards)
    cards.each { |card| @cards << card }
  end

  def show_cards
    player_cards = []
    @cards.each { |card| player_cards << card.type }
    if self.name == "Diler"
      print "Карты дилера: #{player_cards}\n"
    else
      print "Карты игрока: #{player_cards}\n"
    end
  end
end
