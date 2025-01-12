require 'pry'
require './lib/team'
class TeamsCollection
  attr_reader :teams_file, :teams

  def initialize(teams_file)
    @teams_file = teams_file
    @teams = self.read_file
  end

  def read_file
    data = CSV.read(@teams_file, headers: true, header_converters: :symbol)
    data.map do |row|
      Team.new(row)
    end
  end
end
