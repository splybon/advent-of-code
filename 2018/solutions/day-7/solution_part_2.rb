require_relative('../../utils/data_reader.rb')

FILE, WORKERS, ADDITIONAL_SECONDS = if ENV['TEST']
                                      ['test-input.txt', 2, 0]
                                    else
                                      ['input.txt', 5, 60]
                                    end

NUM_TO_INT_MAP=(('A'..'Z').to_a.zip (1..26).to_a).to_h

class SleighKit
  include DataReader

  def initialize
    @input = read_data(File.dirname(__FILE__), FILE)
    @nodes = []
    @edges = []
    @nodes_being_worked_on = []
    @worker_obj = {}
    @seconds = 0
  end

  # Methods for initilization
  def populate_directed_graph
    @input.each do |line|
      @nodes += line.match(/Step (.).+step (.)/).captures
      @edges << @nodes.last(2).join
    end
    @nodes.uniq!.sort!
  end

  def populate_worker_obj
    (1..WORKERS).each { |worker| @worker_obj[worker] = nil }
  end


  # Storing node in hash to track the working value
  def assign_node(char)
    assigned = false
    @worker_obj.each do |k, node|
      break if assigned
      unless node
        @worker_obj[k] = [char, NUM_TO_INT_MAP[char] + ADDITIONAL_SECONDS]
        @nodes_being_worked_on << char
        assigned = true
      end
    end
  end


  def assign_nodes
    # Choosing nodes that are not the originator of the edges and not being currently worked on
    possible_nodes = @edges.map { |edge| edge[0] }.uniq - @nodes_being_worked_on

    # Eliminating all nodes that have an edge directed towards them
    entry_nodes = possible_nodes.select do |node|
      @edges.select { |edge| edge[1] == node}.empty?
    end
    entry_nodes.each { |node| assign_node(node) }
  end

  # removing all stored nodes and edges with this node for a particular node
  def remove_node(node)
    @nodes_being_worked_on.delete(node)
    @nodes.delete(node)
    # the last edge keeps getting ignored when you remove this, so handling the final case
    assign_node(@edges[0][1]) if @edges.size == 1
    @edges.reject! { |edge| edge.include?(node) }
  end

  def process_workers
    @worker_obj.each do |worker, node|
      if node
        node[1] -= 1
        if node[1].zero?
          @worker_obj[worker] = nil
          remove_node(node[0])
        end
      end
    end
  end

  # First assign nodes to workers, and then count the seconds off each worker
  def process_second
    @seconds += 1
    assign_nodes
    process_workers
  end

  def all_nil_workers?
    @worker_obj.all? { |k,v| v.nil? }
  end

  def call
    populate_directed_graph
    populate_worker_obj
    loop do
      process_second
      break if @edges.empty? && all_nil_workers?
    end
    puts "Total Seconds: #{@seconds}"
  end
end

SleighKit.new.call

=begin
real    0m0.146s
user    0m0.127s
sys     0m0.016s
=end