class Gamer
  attr_accessor :name, :money_amount, :cards, :points_amount

  def initialize(*)
    @name
    @money_amount = 100
    @cards = []
    @points_amount = 0
  end

  def take_card(*cards)
    cards.each { |card| @cards << card }
  end
end