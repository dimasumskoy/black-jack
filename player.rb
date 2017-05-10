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
      puts "Карты дилера: #{player_cards}"
      puts "Очки дилера: #{self.points_amount}"
    else
      puts "Карты игрока: #{player_cards}"
      puts "Очки игрока: #{self.points_amount}"
    end
  end

  def count_player_points
    @cards.each { |card| self.points_amount += card.count_point }
  end
end
