require_relative 'player'

class Dealer < Player
  def initialize
    @name = "Dealer"
    super
  end

  def hide_cards
    puts "Карты дилера: #{@cards.collect { "*" }}"
  end
end
