require_relative 'instance_counter'

class Cards
  include InstanceCounter

  @cards = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  class << self
    def deck
      @deck ||= cards_to_deck
    end

    def cards_to_deck
      suits = %w(+ <3 ^ <>)
      deck = []
      suits.each do |suit|
        deck << @cards.collect { |card| card + suit }
      end
      deck.flatten!
    end

    def send_card(card)
      @deck.delete(card)
    end
  end

  attr_accessor :card, :point

  def initialize
    register_instance
    @index = self.class.instances
    @card = self.class.deck[@index - 1]
    count_point
    reset_instance
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

  def reset_instance
    if self.class.instances > 51
      self.class.instances = 0
    end
  end
end