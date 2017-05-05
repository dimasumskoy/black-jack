class Gamer
  attr_accessor :name, :money_amount, :cards, :points_amount

  def initialize(*)
    @money_amount = 100
    @cards = []
    @points_amount = 0
  end

  def take_card(card)
    @cards << card
  end

  def show_cards
    @cards
  end
end