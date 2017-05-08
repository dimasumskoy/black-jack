require_relative 'cards'
require_relative 'diler'
require_relative 'player'
require_relative 'user'
require_relative 'instance_counter'

class Game
  @game_bet = 10
  @game_bank = []

  def new_game
    puts "Игра BlackJack"
    print "Введите имя: "
    @user_name = gets.chomp

    create_user
    create_diler
    init_game
  end

  private

  attr_accessor :user, :diler, :deck

  def bank_amount
    self.class.instance_variable_get(:@game_bank).reduce(:+)
  end

  def reset_game_bank
    self.class.instance_variable_get(:@game_bank).clear
  end

  def replay
    init_game
  end

  def init_game
    update_deck
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
    @bet = self.class.instance_variable_get(:@game_bet)
    @bank = self.class.instance_variable_get(:@game_bank)
    @user.money_amount  -= @bet
    @diler.money_amount -= @bet
    2.times { @bank << @bet }
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
          diler_turn # ход дилера после хода игрока
        end
      when 3
        reveal_cards
      when 4
        new_game
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

  def points_to_zero
    @user.points_amount  = 0
    @diler.points_amount = 0
  end

  def update_deck
    @deck = []
    52.times { @deck << Cards.new } # помещаем все экземпляры карт в колоду игры
  end

  def take_card_from_deck(player)
    i = @deck.size - 1
    @card = @deck[rand(0..i)]
    if @card.type.start_with?("A") && player.points_amount > 10 # присваиваем тузу единицу
      @card.point = 1 
    end
    player.take_card(@card)
    @deck.delete(@card)
    count_points
  end

  def show_user_cards
    @user_cards = []
    @user.cards.each { |card| @user_cards << card.type }
    print "Карты игрока: #{@user_cards}\n"
    print "Очки игрока: #{@user.points_amount}\n"
  end

  def show_diler_cards
    print "Карты дилера: #{@diler.cards.map { |card| card = "*" }}\n"
  end

  def diler_turn
    if @diler.points_amount >= 17
      user_turn
    elsif @diler.cards.size <= 3
      take_card_from_deck(@diler)
    end
  end

  def reveal_cards
    @diler_cards = []
    @diler.cards.each { |card| @diler_cards << card.type }
    print "Карты дилера: #{@diler_cards}\n"
    print "Очки дилера: #{@diler.points_amount}\n"
    puts "------------"
    show_user_cards
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
    reset_game_bank # деньги из банка перешли выигравшему, банк пуст
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
      replay
    else
      puts "Пока!"
      exit
    end
  end
end

Game.new.new_game