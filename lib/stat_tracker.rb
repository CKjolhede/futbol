require 'pry'
require 'CSV'

class StatTracker
  attr_reader :locations

  def initialize(locations)
    @locations = locations
  end

  def self.from_csv(places) #add .to_a changes to an array
    StatTracker.new(places) #creating an instance of StatTracker holding the hash as locations
  end


  def highest_total_score
    games = CSV.read @locations[:games], headers: true, header_converters: :symbol
    scores_array = []
    games.each do |row|
      scores_array << row[:away_goals].to_i + row[:home_goals].to_i
    end
    scores_array.max
  end

  def lowest_total_score
    games = CSV.read @locations[:games], headers: true, header_converters: :symbol
    scores_array = []
    games.each do |row|
      scores_array << row[:away_goals].to_i + row[:home_goals].to_i
    end
    scores_array.min
  end

  def percentage_home_wins
    games = CSV.read @locations[:game_teams], headers: true, header_converters: :symbol
    games_played = 0
    wins = 0
     games.each do |game|
      if game[:hoa] == "home" && game[:results] == "WIN"
        games_played += 1
        wins += 1
      elsif game[:hoa] == "home" && game[:results] == "LOSS"
        games_played += 1
      end
    end
  end
  # binding.pry
end


# locations.each do |location|
#   location.key.to_s = StatTracker.new(location.value)
#   binding.pry
# end
