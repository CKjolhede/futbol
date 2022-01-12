module Calcuable
  def games_in_season(season_id)
    game_ids_in_season = []
    games_in_season_array = []
      @read_games.each do |game|
        if season_id == game.season
          game_ids_in_season << game.game_id
        end
      end
    game_ids_in_season.each do |game_id|
      @read_game_teams.each do |game|
        if game_id == game.game_id
          games_in_season_array << game
        end
      end
    end
    games_in_season_array
    #binding.pry
  end
  def coach_games(season_id)
    coach_games_hash = Hash.new([])
    games = games_in_season(season_id)
      games.each do |game|
        if !coach_games_hash.key?(game.head_coach)
          coach_games_hash[game.head_coach] = []
          coach_games_hash[game.head_coach] << game.result
        elsif coach_games_hash.key?(game.head_coach)
          coach_games_hash[game.head_coach] << game.result
        end
      end
      coach_games_hash
  end
  def coach_win_percent(season_id)
    coaches_hash = coach_games(season_id)
    coach_win_percent_hash = {}
      coaches_hash.each do |coach, win_loss|
        wins = 0
        played = 0
        win_loss.each do |result|
          if result == "WIN"
            wins += 1
            played += 1
          elsif result == "LOSS" || "TIE"
            played += 1
          end
        end
        coach_win_percent_hash[coach] = ((wins.to_f / played.to_f) * 100)
      end
      coach_win_percent_hash

      #binding.pry
  end
end
