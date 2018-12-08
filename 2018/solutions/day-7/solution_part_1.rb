require_relative('../../utils/data_reader.rb')

class SleighKit
  include DataReader

  def initialize
    @input = read_data(File.dirname(__FILE__), 'input.txt')
    @nodes = []
    @edges = []
    @removed_nodes = ''
    @solved = false
  end

  def populate_directed_graph
    @input.each do |line|
      @nodes += line.match(/Step (.).+step (.)/).captures
      @edges << @nodes.last(2).join
    end
    @nodes.uniq!.sort!
  end

  def find_next_node
    # Choosing nodes that are not the originator of the edges
    possible_nodes = @edges.map { |edge| edge[0] }.uniq

    # Eliminating all nodes that have an edge directed towards them
    entry_nodes = possible_nodes.select do |node|
      @edges.select { |edge| edge[1] == node}.empty?
    end
    entry_nodes.sort.first
  end

  def add_node_to_list(node)
    @removed_nodes += node
    @nodes.delete(node)
    @removed_nodes += @edges[0][1] if @edges.size == 1
    @edges.reject! { |edge| edge.include?(node) }
  end

  def call
    populate_directed_graph
    loop do
      node = find_next_node
      break unless node
      add_node_to_list(node)
    end
    puts "Order of Sleigh Kit: #{@removed_nodes}"
  end
end

SleighKit.new.call

=begin
PLAN
This is a directed graph

Store the edges in an array and the nodes in an array
To find which one to do first, look at the edges to see the directions
=end

=begin
real    0m0.092s
user    0m0.062s
sys     0m0.018s
=end