require_relative('../../utils/data_reader.rb')
include DataReader

input = read_data(File.dirname(__FILE__))

# Using a hash to plot instead of 2-d array.  Will have less null values
# Need global variables to access inside of methods
# Hash key will be an array of coords
$claims = {}

# a claim looks like #5 @ 769,790: 22x13
# using regex to parse out the coordinates and size
def parse_claim(claim)
  captures = claim.match(/@ (.+): (.+)/).captures
  coordinates = captures[0].split(',').map(&:to_i)
  size = captures[1].split('x').map(&:to_i)
  [coordinates, size]
end

def add_claim(coordinates, size)
  # Setting coordinates for plotting
  x_min = coordinates[0]
  x_max = coordinates[0] + size[0] - 1
  y_min = coordinates[1]
  y_max = coordinates[1] + size[1] - 1

  (x_min..x_max).each do |x_coord|
    (y_min..y_max).each do |y_coord|
      coordinate = [x_coord, y_coord]
      $claims[coordinate] = ($claims[coordinate] || 0) + 1
    end
  end
end

# Count the values that are 2 or greater
def count_claim
  count = $claims.values.inject { |sum, n| n >= 2 ? (sum + 1) : sum } - 1
  puts "count: #{count}"
end

input.each do |claim|
  coordinates, size = parse_claim(claim)
  add_claim(coordinates, size)
end

count_claim

=begin
real    0m0.945s
user    0m0.899s
sys     0m0.039s
=end
