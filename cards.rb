class Cards
  @cards = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  def self.deck
    @deck ||= cards_to_deck
  end

  def self.cards_to_deck
    suits = %w(+ <3 ^ <>)
    deck = []
    suits.each do |suit|
      deck << @cards.collect { |card| card + suit }
    end
    deck.flatten
  end

  attr_accessor :card, :point

  def initialize
    @card = self.class.deck[rand(0..52)]
    count_point
  end

  def count_point
    if @card.start_with?("J", "Q", "K")
      @point = 10 
    elsif @card.start_with?("A")
      @point = 11
    else
      @point = @card.to_i
    end
  end
end