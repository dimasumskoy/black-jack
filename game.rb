require_relative 'cards'
require_relative 'deck'
require_relative 'dealer'
require_relative 'player'
require_relative 'user'

class Game
  GAME_BET = 10

  def initialize
    new_game
  end

  private

  attr_accessor :user, :dealer, :deck, :game_bank

  def new_game
    puts "Игра BlackJack"
    print "Введите имя: "
    user_name = gets.chomp
    create_user(user_name)
    create_dealer
    init_game
  end

  def init_game
    game_bank
    update_deck
    deal_cards
    count_points
    bet
    user_turn
  end

  def create_user(name)
    @user = User.new(name)
  end

  def create_dealer
    @dealer = Dealer.new
  end

  def update_deck
    @deck = Deck.new
  end

  def deal_cards
    @user.cards.clear
    @dealer.cards.clear
    2.times do
      @deck.take_card_from_deck(@user)
      @deck.take_card_from_deck(@dealer)
    end
  end

  def count_points
    @user.points_amount  = 0
    @dealer.points_amount = 0
    @user.count_player_points
    @dealer.count_player_points
  end

  def game_bank
    @game_bank = 0
  end

  def bet
    @user.money_amount  -= GAME_BET
    @dealer.money_amount -= GAME_BET
    2.times { @game_bank += GAME_BET }
  end

  def user_turn
    loop do
      hide_dealer_cards
      puts "------------"
      @user.show_cards
      puts "------------"
      puts "Банк игры: #{@game_bank}"
      show_menu

      case @choice
      when 1 then dealer_turn
      when 2
        if @user.cards.size >= 3
          puts "У вас максимальное количество карт"
        else
          @deck.take_card_from_deck(@user)
          count_points
          dealer_turn
        end
      when 3 then reveal_cards
      when 4 then new_game
      when 5 then puts "Пока!"; exit
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
    @choice = gets.to_i
  end

  def hide_dealer_cards
    hidden_cards = @dealer.cards.collect { "*" }
    puts "Карты дилера: #{hidden_cards}"
  end

  def dealer_turn
    if @dealer.points_amount >= 17
      user_turn
    elsif @dealer.cards.size < 3
      @deck.take_card_from_deck(@dealer)
      count_points
    end
  end

  def reveal_cards
    @dealer.show_cards
    puts "------------"
    @user.show_cards
    determine_winner
    play_again
  end

  def determine_winner
    user_points = @user.points_amount
    dealer_points = @dealer.points_amount
    if user_points > 21 && dealer_points > 21 || user_points == dealer_points
      standoff
    else
      player = [@user, @dealer].reject { |player| player.points_amount > 21 }
      player_victory(player.max_by(&:points_amount))
    end
  end

  def player_victory(player)
    player.money_amount += @game_bank
    puts "------------"
    puts "Победил #{player.name}"
    puts "Выигрыш: #{@game_bank}"
    puts "Текущий счет: #{@user.money_amount}"
  end

  def standoff
    puts "------------"
    puts "Ничья"
    puts "Выигрыш: #{GAME_BET}"
    puts "Текущий счет: #{@user.money_amount}"
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