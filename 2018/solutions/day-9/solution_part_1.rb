require_relative('../../utils/data_reader.rb')
# Works for solution but not other example ones

class MarbleMania
  include DataReader

  def initialize
    input = read_data(File.dirname(__FILE__), 'input.txt')[0]
    @total_players, @last_marble = input.match(/(.+) pla.+th (.+) /).captures.map(&:to_i)
    @current_player = 5
    @current_marble = 4
    @count = 4
    @circle = [0,4,2,1,3]
    @scores = Hash[*(1..@total_players).inject([]) { |acc, player| acc += [player, 0] }]
  end

  def score_marble(index)
    index = (index - 7)
    if index < 0
      index = @circle.length + index
    end
    old_marble = @circle[index]

    @scores[@current_player] = (@scores[@current_player] || 0) + old_marble + @current_marble
    @circle.delete(old_marble)
    @current_marble = if index == @circle.length
                        @circle[0]
                      else
                        @circle[index]
                      end
  end

  def place_marble
    index = @circle.find_index(@current_marble)
    @current_marble = @count
    if @current_marble % 23 == 0
      score_marble(index)
    else
      index += 2
      if index > @circle.length
        index = index % @circle.length
        @circle.insert(index, @current_marble)
      else
        @circle.insert(index, @current_marble)
      end
    end
  end

  def advance_player
    @current_player += 1
    @current_player = 1 if @current_player >= @total_players + 1
  end

  def call
    while @current_marble < @last_marble
      @count += 1
      place_marble
      advance_player
    end
    puts "Highest Score: #{@scores.max_by {|_k, v| v}[1]}"
  end
end

MarbleMania.new.call

=begin
Had some trouble dealing with going back around the array for the different list
Handling cases of going from end to beginning, and beginning to end was difficult
Decided to just start a couple of marbles in b/c it was hard to get it going with this approach.

real    0m51.671s
user    0m51.491s
sys     0m0.111s
=end

