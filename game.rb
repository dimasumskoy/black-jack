require_relative 'cards'
require_relative 'deck'
require_relative 'diler'
require_relative 'player'
require_relative 'user'

class Game
  GAME_BET = 10

  def initialize
    new_game
  end

  private

  attr_accessor :user, :diler, :deck, :game_bank

  def new_game
    puts "Игра BlackJack"
    print "Введите имя: "
    user_name = gets.chomp
    create_user(user_name)
    create_diler
    init_game
  end

  def init_game
    update_deck
    deal_cards
    count_points
    bet
    user_turn
  end

  def create_user(name)
    @user = User.new(name)
  end

  def create_diler
    @diler = Diler.new
  end

  def update_deck
    @deck = Deck.new
  end

  def deal_cards
    @user.cards.clear
    @diler.cards.clear
    2.times do
      @deck.take_card_from_deck(@user)
      @deck.take_card_from_deck(@diler)
    end
  end

  def count_points
    @user.points_amount  = 0
    @diler.points_amount = 0
    @user.count_points
    @diler.count_points
  end

  def bet
    @game_bank ||= 0
    @user.money_amount  -= GAME_BET
    @diler.money_amount -= GAME_BET
    2.times { @game_bank += GAME_BET }
  end

  def user_turn
    loop do
      hide_diler_cards
      puts "------------"
      @user.show_cards
      puts "------------"
      show_menu

      case @choice = gets.to_i
      when 1
        diler_turn
      when 2
        if @user.cards.size >= 3
          puts "У вас максимальное количество карт"
        else
          @deck.take_card_from_deck(@user)
          count_points
          diler_turn
        end
      when 3
        reveal_cards
      when 4
        self.class.new
      when 5
        puts "Пока!"
        exit
      end
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
    puts "4. Начать игру заново"
    puts "5. Выход из игры"
  end

  def hide_diler_cards
    hidden_cards = @diler.cards.collect { "*" }
    puts "Карты дилера: #{hidden_cards}"
  end

  def diler_turn
    if @diler.points_amount >= 17
      user_turn
    elsif @diler.cards.size < 3
      @deck.take_card_from_deck(@diler)
      count_points
    end
  end

  def reveal_cards
    @diler.show_cards
    puts "------------"
    @user.show_cards

    determine_winner
    play_again
  end

  def determine_winner
    if @user.points_amount > @diler.points_amount && @user.points_amount <= 21
      user_victory
    elsif @diler.points_amount > @user.points_amount && @diler.points_amount <= 21
      diler_victory
    elsif @user.points_amount <= 21 && @diler.points_amount > 21
      user_victory
    elsif @diler.points_amount <= 21 && @user.points_amount > 21
      diler_victory
    elsif @user.points_amount == @diler.points_amount
      puts "Ничья"
      @user.money_amount  += @bet
      @diler.money_amount += @bet
      puts "Выигрыш: #{@bet}"
      show_user_score
    end
    game_bank
  end

  def user_victory
    puts "Победил #{@user.name}!"
    @user.money_amount += bank_amount
    puts "Выигрыш: #{bank_amount}"
    show_user_score
  end

  def diler_victory
    puts "Победил Diler"
    @diler.money_amount += bank_amount
    show_user_score
  end

  def show_user_score
    puts "Ваши деньги: #{@user.money_amount}"
  end

  def play_again
    puts "Сыграть еще раз? (да/нет)"
    answer = gets.chomp
    if answer == "да".downcase
      init_game
    else
      puts "Пока!"
      exit
    end
  end
end

Game.new