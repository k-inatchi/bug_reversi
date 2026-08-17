# frozen_string_literal: true

require_relative './lib/reversi_methods'

class Reversi
  include ReversiMethods

  QUIT_COMMANDS = %w[quit exit q].freeze

  def initialize
    @board = build_initial_board
    @current_stone = BLACK_STONE
  end

  def run
    loop do
      output(@board)

      if finished?(@board)
        print_result
        break
      end

      unless placeable?(@board, @current_stone)
        skip_turn
        next
      end

      print "command? (#{@current_stone == WHITE_STONE ? '白○' : '黒●'}) > "
      command = gets.chomp
      break if QUIT_COMMANDS.include?(command)

      place_stone(command)
    end

    puts 'finished!'
  end

  private

  def toggle_stone
    @current_stone = @current_stone == WHITE_STONE ? BLACK_STONE : WHITE_STONE
  end

  def print_result
    puts '試合終了'
    puts "白○:#{count_stone(@board, WHITE_STONE)}"
    puts "黒●:#{count_stone(@board, BLACK_STONE)}"
  end

  def skip_turn
    puts '詰みのためターンを切り替えます'
    toggle_stone
  end

  def next_turn
    puts '配置成功、次のターン'
    toggle_stone
  end

  def place_stone(command)
    if put_stone(@board, command, @current_stone)
      next_turn
    else
      puts '配置失敗、ターン据え置き'
    end
  rescue StandardError => e
    puts "ERROR: #{e.message}"
  end
end

Reversi.new.run if __FILE__ == $PROGRAM_NAME
