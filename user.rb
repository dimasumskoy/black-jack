require_relative 'gamer'

class User < Gamer

  def initialize(name)
    @name = name
    super
  end
end