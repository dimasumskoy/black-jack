require_relative 'cards'
require_relative 'diler'
require_relative 'player'
require_relative 'user'

class Game
  @game_bet = 10
  @game_bank = []

  def self.game_bank
    @game_bank.reduce(:+)
  end

  attr_accessor :user, :diler

  def new_game
    puts "Игра BlackJack"
    print "Введите имя: "
    @user_name = gets.chomp

    create_user
    create_diler
    init_game
  end

  def replay
    init_game
  end

  def init_game
    deal_cards
    total_points
    bet
    user_turn
  end

  def create_user
    @user = User.new(@user_name)
  end

  def create_diler
    @diler = Diler.new
  end

  def deal_cards
    @user.cards.clear
    @diler.cards.clear
    2.times do
      @user.take_card(Cards.new)
      @diler.take_card(Cards.new)
    end
  end

  def total_points
    @user.cards.each  { |card| @user.points_amount  += card.point }
    @diler.cards.each { |card| @diler.points_amount += card.point }
  end

  def bet
    bet = self.class.instance_variable_get(:@game_bet)
    @user.money_amount  -= bet
    @diler.money_amount -= bet
    2.times { self.class.instance_variable_get(:@game_bank) << bet }
  end

  def user_turn
    puts "Выберите действие:"
    puts "1. Пропустить ход"
    puts "2. Добавить карту"
    puts "3. Открыть карты"
    choice = gets.to_i
  end
end
