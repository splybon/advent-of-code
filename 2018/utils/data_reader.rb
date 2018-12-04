module DataReader
  def read_data(file_path)
    File.readlines("#{file_path}/input.txt")
  end
end

=begin
use like
require_relative('../../utils/data_reader.rb')
include DataReader

read_data(File.dirname(__FILE__))
=end