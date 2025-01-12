require 'pry'
require 'CSV'
require './lib/games_collection'
require './lib/teams_collection'
require './lib/games_teams_collection'
require './lib/season_stats'
require './lib/calcuable'


class StatTracker
include Calcuable
  attr_reader :locations

  def initialize(locations)
    @locations = locations
    @games_file = GamesCollection.new(@locations[:games])
    @teams_file = TeamsCollection.new(@locations[:teams])
    @game_teams_file = GamesTeamsCollection.new(@locations[:game_teams])
    @read_games = @games_file.read_file
    @read_teams = @teams_file.read_file
    @read_game_teams = @game_teams_file.read_file
    #@season_stats = SeasonStats.new
  end


  def self.from_csv(files) #add .to_a changes to an array\
    #binding.pry
    StatTracker.new(files) #creating an instance of StatTracker holding the hash as locations
  end

  def highest_total_score
    scores_array = [] #helper method later
    @read_games.each do |row|
      #binding.pry
      scores_array << row.home_goals.to_i + row.away_goals.to_i
    end
    scores_array.max
  end

  def lowest_total_score
    scores_array = [] #helper method later
    @read_games.each do |row|
      #binding.pry
      scores_array << row.home_goals.to_i + row.away_goals.to_i
    end
    scores_array.min
  end

  def self.from_csv(files)
    StatTracker.new(files)
  end


  def count_of_teams
    @read_teams.size
  end

  def percentage_home_wins
    games_played = 0
    wins = 0

     @read_game_teams.each do |game|
      if game.hoa == "home" && game.result == "WIN"
        games_played += 1
        wins += 1
      elsif game.hoa == "home" && game.result == "LOSS"
        games_played += 1
      end
    end
      (wins.to_f / games_played.to_f).round(2)
   end

  def best_offense
    hash_team_stats = {}
    @read_game_teams.each do |row|
      if hash_team_stats[row.team_id].nil?
        hash_team_stats[row.team_id] = [row.goals.to_i]
      else
        hash_team_stats[row.team_id] << row.goals.to_i
      end
    end

    team_stats = average_goals(hash_team_stats)

    highest_average_goals = team_stats.max_by {|team_id, team_id_value| team_id_value}

    @read_teams.find_all do |row|
      return row.teamname if highest_average_goals[0] == row.team_id
    end
  end

  def average_goals(argument_1)
    result_2 = {}
    argument_1.each do |key, value|
      result_2[key] = value.sum / value.size.to_f
    end
  end

  def worst_offense
    hash_team_stats = {}
    @read_game_teams.each do |row|
      if hash_team_stats[row.team_id].nil?
        hash_team_stats[row.team_id] = [row.goals.to_i]
      else
        hash_team_stats[row.team_id] << row.goals.to_i
      end
    end

    team_stats = {}
    hash_team_stats.each do |key, value|
      team_stats[key] = value.sum / value.size.to_f
    end

    lowest_average_goals = team_stats.min_by {|team_id, team_id_value| team_id_value}

    @read_teams.find_all do |row|
      return row.teamname if lowest_average_goals[0] == row.team_id
    end
  end

  def highest_scoring_visitor
    hash_for_away_teams = {}
    @read_games.each do |row|
      if hash_for_away_teams[row.away_team_id].nil?
        hash_for_away_teams[row.away_team_id] = [row.away_goals.to_i]
      else
        hash_for_away_teams[row.away_team_id] << row.away_goals.to_i
      end
    end

    hash_for_average_goals_away = {}
    hash_for_away_teams.each do |team_id, team_id_goals|
      hash_for_average_goals_away[team_id] = team_id_goals.sum / team_id_goals.size.to_f
    end

    away_highest_average = hash_for_average_goals_away.max_by {|team_id, team_id_goals| team_id_goals}

    @read_teams.find_all do |row|
      return row.teamname if away_highest_average[0] == row.team_id
    end
  end

  def highest_scoring_home_team
    hash_for_home_teams = {}
    @read_games.each do |row|
      if hash_for_home_teams[row.home_team_id].nil?
        hash_for_home_teams[row.home_team_id] = [row.home_goals.to_i]
      else
        hash_for_home_teams[row.home_team_id] << row.home_goals.to_i
      end
    end

    hash_for_average_goals_home = {}
    hash_for_home_teams.each do |team_id, team_id_goals|
      hash_for_average_goals_home[team_id] = team_id_goals.sum / team_id_goals.size.to_f
    end

    home_highest_average = hash_for_average_goals_home.max_by {|team_id, team_id_goals| team_id_goals}

    @read_teams.find_all do |row|
      return row.teamname if home_highest_average[0] == row.team_id
    end
  end

  def lowest_scoring_visitor
    hash_for_away_teams = {}
    @read_games.each do |row|
      if hash_for_away_teams[row.away_team_id].nil?
        hash_for_away_teams[row.away_team_id] = [row.away_goals.to_i]
      else
        hash_for_away_teams[row.away_team_id] << row.away_goals.to_i
      end
    end

    hash_for_average_goals_away = {}
    hash_for_away_teams.each do |team_id, team_id_goals|
      hash_for_average_goals_away[team_id] = team_id_goals.sum / team_id_goals.size.to_f
    end

    away_lowest_average = hash_for_average_goals_away.min_by {|team_id, team_id_goals| team_id_goals}

    @read_teams.find_all do |row|
      return row.teamname if away_lowest_average[0] == row.team_id
    end
  end

  def lowest_scoring_home_team
    hash_for_home_teams = {}
    @read_games.each do |row|
      if hash_for_home_teams[row.home_team_id].nil?
        hash_for_home_teams[row.home_team_id] = [row.home_goals.to_i]
      else
        hash_for_home_teams[row.home_team_id] << row.home_goals.to_i
      end
    end

    hash_for_average_goals_home = {}
    hash_for_home_teams.each do |team_id, team_id_goals|
      hash_for_average_goals_home[team_id] = team_id_goals.sum / team_id_goals.size.to_f
    end

    home_lowest_average = hash_for_average_goals_home.min_by {|team_id, team_id_goals| team_id_goals}

    @read_teams.find_all do |row|
      return row.teamname if home_lowest_average[0] == row.team_id
    end
  end

  def percentage_ties
    games_played = 0
    ties = 0
     @read_game_teams.each do |game|
      if game.result == "TIE"
        games_played += 1
        ties += 1
      else
        games_played += 1
      end
    end
      (ties.to_f / games_played.to_f).round(2)
  end

  def percentage_visitor_wins
    games_played = 0
    wins = 0
     @read_games.each do |game|
      if game.away_goals.to_i > game.home_goals.to_i
        games_played += 1
        wins += 1
      elsif
        games_played += 1
      end
    end
    # binding.pry
      (wins.to_f / games_played.to_f).round(2)
  end

  def percentage_ties
    games_played = 0
    wins = 0
     @read_games.each do |game|
      if game.away_goals.to_i == game.home_goals.to_i
        games_played += 1
        wins += 1
      elsif
        games_played += 1
      end
    end
    # binding.pry
      (wins.to_f / games_played.to_f).round(2)
  end

  def count_of_games_by_season
    @games_by_season = {}
    seasons = seasons_list
    # seasons = @read_games.map do |game|
    #   game.season
    # end.uniq
    #binding.pry
    games_seasons = @read_games.map do |game|
      game.season
    end
    seasons.each do |season_id|
      @games_by_season[season_id] = games_seasons.count(season_id)
    end


    #binding.pry
    @games_by_season
  end
  # binding.pry
  def average_goals_per_game
    @total_goals = 0
    @read_games.each do |home|
      @total_goals += (home.home_goals.to_f + home.away_goals.to_f)
    end
    (@total_goals.to_f / @read_games.count).round(2)
    # binding.pry
  end

  def average_goals_by_season
    @seasons = @read_games.map do |game|
      game.season
    end.uniq
    total_goals_by_season = Hash.new(0)
    @read_games.each do |game|
        total_goals_by_season[game.season] += (game.home_goals.to_f + game.away_goals.to_f)
    end
    average_goals_by_season = {} #Hash.new(0)

    # binding.pry
    @seasons.each do |w|
        average_goals_by_season[w] = (total_goals_by_season[w].to_f / count_of_games_by_season[w].to_f).round(2)
        # average_goals_by_season.transform_values! { |v| (total_goals_by_season[w].to_i / count_of_games_by_season[w].to_i)}
        # binding.pry
    end
    average_goals_by_season
  end

  def winningest_coach (season_id)
       coach = coach_win_percent(season_id).max_by {|coach, percent| percent}
       coach[0]
  end

  def worst_coach (season_id)
    coach = coach_win_percent(season_id).min_by {|coach, percent| percent}
    coach[0]
  end

  def most_accurate_team(season_id)
    # team_ids_game_hash = team_ids_game
    team_ids_game_hash = Hash.new([])
    games = games_in_season(season_id)
      games.each do |game|
        if !team_ids_game_hash.key?(game.team_id)
          team_ids_game_hash[game.team_id] = []
          team_ids_game_hash[game.team_id] << game
        elsif team_ids_game_hash.key?(game.team_id)
          team_ids_game_hash[game.team_id] << game
        end
      end
      team_shot_percentage_hash = {}
      team_ids_game_hash.each do |team_id, games|
        shots = 0
        goals = 0
        games.each do |game|
          shots += game.shots.to_i
          goals += game.goals.to_i
        end
        team_shot_percentage_hash[team_id] = ((goals.to_f / shots.to_f) * 100)
      end
      max_shot_percentage = team_shot_percentage_hash.max_by {|team_id, percent| percent}
      teamid = max_shot_percentage[0]
      max_team = @read_teams.find do |team|
        team.team_id == teamid
      end
      max_team.teamname
  end

  def least_accurate_team (season_id)
    team_ids_game_hash = Hash.new([])
    games = games_in_season(season_id)
      games.each do |game|
        if !team_ids_game_hash.key?(game.team_id)
          team_ids_game_hash[game.team_id] = []
          team_ids_game_hash[game.team_id] << game
        elsif team_ids_game_hash.key?(game.team_id)
          team_ids_game_hash[game.team_id] << game
        end
      end
      team_shot_percentage_hash = {}
      team_ids_game_hash.each do |team_id, games|
        shots = 0
        goals = 0
        games.each do |game|
          shots += game.shots.to_i
          goals += game.goals.to_i
        end
        team_shot_percentage_hash[team_id] = ((goals.to_f / shots.to_f) * 100)
      end
      min_shot_percentage = team_shot_percentage_hash.min_by {|team_id, percent| percent}
      teamid = min_shot_percentage[0]
      min_team = @read_teams.find do |team|
        team.team_id == teamid
      end
    min_team.teamname
  end

  def most_tackles (season_id)
    team_ids_game_hash = Hash.new([])
    games = games_in_season(season_id)
      games.each do |game|
        if !team_ids_game_hash.key?(game.team_id)
          team_ids_game_hash[game.team_id] = []
          team_ids_game_hash[game.team_id] << game
        elsif team_ids_game_hash.key?(game.team_id)
          team_ids_game_hash[game.team_id] << game
        end
      end

      team_tackle_hash = {}
      team_ids_game_hash.each do |team_id, games|
        tackles = 0
        games.each do |game|
          tackles += game.tackles.to_i
        end
        team_tackle_hash[team_id] = tackles
      end
      max_tackles = team_tackle_hash.max_by {|team_id, tackles| tackles}
      teamid = max_tackles[0]
      max_team = @read_teams.find do |team|
        team.team_id == teamid
      end
    max_team.teamname
  end

  def fewest_tackles (season_id)
    team_ids_game_hash = Hash.new([])
    games = games_in_season(season_id)
      games.each do |game|
        if !team_ids_game_hash.key?(game.team_id)
          team_ids_game_hash[game.team_id] = []
          team_ids_game_hash[game.team_id] << game
        elsif team_ids_game_hash.key?(game.team_id)
          team_ids_game_hash[game.team_id] << game
        end
      end

      team_tackle_hash = {}
      team_ids_game_hash.each do |team_id, games|
        tackles = 0
        games.each do |game|
          tackles += game.tackles.to_i
        end
        team_tackle_hash[team_id] = tackles
      end
      min_tackles = team_tackle_hash.min_by {|team_id, tackles| tackles}
      teamid = min_tackles[0]
      min_team = @read_teams.find do |team|
        team.team_id == teamid
      end
    min_team.teamname
  end

  def team_info

  end

  def best_season(team_id)
    seasons = @read_games.map do |game|
      game.season
    end.uniq
    rich_wants_hash = Hash.new
    seasons.each do |season_id|
      games = games_in_season(season_id)
      seasons_game_hash = Hash.new([])
        games.each do |game|
          if !seasons_game_hash.key?(game.team_id)
            seasons_game_hash[game.team_id] = []
            seasons_game_hash[game.team_id] << game
          elsif seasons_game_hash.key?(game.team_id)
            seasons_game_hash[game.team_id] << game
          end
        end
        rich_wants_hash[season_id] = seasons_game_hash
      end

      season_percent_hash = Hash.new
      rich_wants_hash.each do |season, games|
        wins = 0
        played = 0
        games.each do |game|
          if game.result == "WIN" #throwwing an error for result
            wins += 1
            played += 1
          elsif game.result == "LOSS" || "TIE" #throwing an error for result
            played += 1
          end
        end
        season_percent_hash[season] = ((wins.to_f / played.to_f) * 100)
      end
      best_season_percentage = season_percent_hash.max_by {|season, percent| percent}
      best_season_percentage[0]
      binding.pry
  end
end
