require_relative 'cards'
require_relative 'diler'
require_relative 'player'
require_relative 'user'
require_relative 'instance_counter'

class Game
  @game_bet = 10
  @game_bank = []

  def self.game_bank
    @game_bank.reduce(:+)
  end

  attr_accessor :user, :diler, :deck

  def new_game
    puts "Игра BlackJack"
    print "Введите имя: "
    @user_name = gets.chomp

    reset_game_bank
    update_deck
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
      take_card_from_deck(@user)
      take_card_from_deck(@diler)
    end
  end

  def total_points
    count_points
  end

  def count_points
    points_to_zero
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
    loop do
      show_diler_cards
      puts "------------"
      show_user_cards
      show_menu

      case @choice = gets.to_i
      when 1
        diler_turn
      when 2
        if @user.cards.size >= 3
          puts "У вас максимальное количество карт"
        else
          take_card_from_deck(@user)
        end
      when 3
        reveal_cards
      when 4
        puts "Goodbye"
        exit
      end
    end
  end

  def points_to_zero
    @user.points_amount  = 0
    @diler.points_amount = 0
  end

  def update_deck
    @deck = []
    52.times { @deck << Cards.new }
  end

  def take_card_from_deck(player)
    i = @deck.size - 1
    @card = @deck[rand(0..i)]
    if @card.type.start_with?("A") && player.points_amount > 10
      @card.point = 1
    end
    player.take_card(@card)
    @deck.delete(@card)
    count_points
  end

  def deck
    @deck.each { |card| p card }
    @deck.size
  end

  def show_user_cards
    @user_cards = []
    @user.cards.each { |card| @user_cards << card.type }
    print "Player cards: #{@user_cards}\n"
    print "Player points: #{@user.points_amount}\n"
  end

  def show_diler_cards
    print "Diler cards: #{@diler.cards.map { |card| card = "*" }}\n"
  end

  def diler_turn
    if @diler.points_amount >= 17
      user_turn
    else
      take_card_from_deck(@diler)
    end
  end

  def show_menu
    puts "Ход игрока"
    puts "1. Пропустить ход"
    if @user.cards.size >= 3
      puts "2. Добавить карту (недоступно)"
    else
      puts "2. Добавить карту"
    end
    puts "3. Открыть карты"
    puts "4. Выход из игры"
  end

  def reveal_cards

  end

  def reset_game_bank
    self.class.instance_variable_get(:@game_bank).clear
  end
end
