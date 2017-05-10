require_relative 'cards'

class Deck
  VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  SUITS  = %w(+ <3 ^ <>)

  attr_accessor :cards

  def initialize
    @cards = build_deck
  end

  def take_card_from_deck(player)
    @card = @cards[0]
    @card.change_ace_point(player)
    player.take_card(@card)
    @cards.delete(@card)
  end

  private

  def build_deck
    SUITS.flat_map do |suit|
      VALUES.collect do |value|
        Cards.new(value + suit)
      end
    end.shuffle!
  end
end