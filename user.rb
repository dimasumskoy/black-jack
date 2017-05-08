require_relative 'player'

class User < Player
  def initialize(name)
    @name = name
    super
  end
end
