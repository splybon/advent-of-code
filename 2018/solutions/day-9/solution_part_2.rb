require_relative('../../utils/data_reader.rb')
# Works for solution but not other example ones

# Using as node of a doubly-linked list
class CircleNode
  attr_accessor :next_node, :prev_node
  attr_reader :value

  def initialize(value, next_node=nil, prev_node=nil)
    @value = value
    @next_node = next_node || self
    @prev_node = prev_node || self
  end

  # Adds new node just in front of this one
  def insert_new(value)
    new_node = CircleNode.new(value, @next_node, self)
    @next_node.prev_node = new_node
    self.next_node = new_node
    new_node
  end

  # removes node from the linked list
  def remove
    @prev_node.next_node = @next_node
    self
  end
end

# Manages the linked list of circle nodes
class MarbleMania
  include DataReader

  def initialize
    input = read_data(File.dirname(__FILE__), 'input.txt')[0]
    @total_players, @last_marble = input.match(/(.+) pla.+th (.+) /).captures.map(&:to_i)
    @last_marble *= 100 # Added for part 2
    @current_player = 1
    @current_marble = CircleNode.new(0)
    @count = 0
    @scores = Hash[*(1..@total_players).inject([]) { |acc, player| acc += [player, 0] }]
  end

  # Take marble 7 spots before it in the list and remove it.
  # Add to the score the current marble and the removed marble
  def score_marble
    marble = @current_marble
    7.times do
      marble = marble.prev_node
    end

    marble.remove
    old_marble_score = marble.value
    @current_marble = marble.next_node

    @scores[@current_player] = (@scores[@current_player] || 0) + old_marble_score + @count
  end

  def place_marble
    if @count % 23 == 0
      score_marble
    else
      # Places new marble 2 spots in front of current one
      @current_marble = @current_marble.next_node.insert_new(@count)
    end
  end

  def advance_player
    @current_player += 1
    @current_player = 1 if @current_player >= @total_players + 1
  end

  def call
    while @current_marble.value < @last_marble
      @count += 1
      place_marble
      advance_player
    end
    puts "Highest Score: #{@scores.max_by {|_k, v| v}[1]}"
  end
end

MarbleMania.new.call

=begin
Rewriting to use a linked list instead of an array implementation.
The linked list is much faster at insertions which this has to do a lot of.
Soooooo much faster than an array. Overall pretty pleased with this solution

real    0m4.728s
user    0m4.445s
sys     0m0.277s
=end

