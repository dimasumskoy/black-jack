require_relative 'deck'

class Cards
  attr_accessor :type, :point

  def initialize(type)
    @type = type
  end

  def count_point
    if @type.start_with?("J", "Q", "K")
      @point = 10
    elsif @type.start_with?("A")
      @point = 11
    else
      @point = @type.to_i
    end
  end

  def change_ace_point(player)
    if self.type.start_with?("A") && player.points_amount > 10
      self.point = 1
    end
  end
end
