require_relative 'instance_counter'

class Cards
  include InstanceCounter

  @cards = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  class << self
    def deck
      @deck ||= cards_to_deck # помещаем все условные обозначения карт в условную колоду
    end

    def cards_to_deck # присоединяем каждому номиналу карты условное обозначение
      suits = %w(+ <3 ^ <>)
      deck = []
      suits.each do |suit|
        deck << @cards.collect { |card| card + suit }
      end
      deck.flatten!
    end
  end

  attr_accessor :type, :point

  def initialize
    register_instance
    @index = self.class.instances # для создания экземпляров карт и помещения их в колоду игры
    @type = self.class.deck[@index - 1]
    count_point
    reset_instance
  end

  private

  def count_point
    if @type.start_with?("J", "Q", "K")
      @point = 10
    elsif @type.start_with?("A")
      @point = 11
    else
      @point = @type.to_i
    end
  end

  def reset_instance
    self.class.instances = 0 if self.class.instances > 51
  end
end
