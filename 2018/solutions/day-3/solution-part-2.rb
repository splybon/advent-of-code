require 'pry'
require_relative('../../utils/data_reader.rb')
include DataReader

input = read_data(File.dirname(__FILE__))

# Using a hash to plot instead of 2-d array.  Will have less null values
# Need global variables to access inside of methods
# Hash key will be an array of coords
$claims = {}

# Storing if the claim id has been overlapped multiple times
$claim_ids = {}

# a claim looks like #5 @ 769,790: 22x13
# using regex to parse out the coordinates and size
def parse_claim(claim)
  captures = claim.match(/#(.+) @ (.+): (.+)/).captures
  {
    id: captures[0].to_i,
    coordinates: captures[1].split(',').map(&:to_i),
    size: captures[2].split('x').map(&:to_i),
  }
end

def add_claim(coordinates:, size:, id:)
  # Needing to set to false b/c ||= will fail if set default to true
  $claim_ids[id.to_s] ||= false

  # Setting coordinates for plotting
  x_min = coordinates[0]
  x_max = coordinates[0] + size[0] - 1
  y_min = coordinates[1]
  y_max = coordinates[1] + size[1] - 1

  (x_min..x_max).each do |x_coord|
    (y_min..y_max).each do |y_coord|
      coordinate = [x_coord, y_coord]
      $claims[coordinate] = ($claims[coordinate] || '') + "-#{id}"
      ids = $claims[coordinate].split('-').reject(&:empty?)
      ids.each { |id| $claim_ids[id.to_s] = true } if ids.length > 1
    end
  end
end

# Count the values that are 2 or greater
def find_claim
  key = $claim_ids.select { |k, v| !v}.keys[0]
  puts "key: #{key}"
end

input.each do |claim|
  data_obj = parse_claim(claim)
  add_claim(**data_obj)
end

find_claim

=begin
Time
real    0m2.249s
user    0m2.160s
sys     0m0.081s
=end