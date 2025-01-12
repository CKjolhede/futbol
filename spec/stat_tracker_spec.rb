require './lib/stat_tracker'
require './lib/games_collection'
require 'pry'


RSpec.describe StatTracker do
  before(:each) do
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    @locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
      }
    @stat_tracker = StatTracker.from_csv(@locations)
  end

  it 'exists' do
    stat_tracker = StatTracker.new(@locations)

    expect(stat_tracker).to be_a(StatTracker)
  end

  it 'from CSV create new StatTracker' do
    stat_tracker = StatTracker.from_csv(@locations)
    expect(stat_tracker).to be_a(StatTracker)
    expect(stat_tracker.locations).to eq(@locations)
  end


  it '#count_of_teams can count total number of teams' do
    expect(@stat_tracker.count_of_teams).to eq(32)
  end

  it '#best_offense can find the team with highest average number of goals scored' do
    expect(@stat_tracker.best_offense).to eq("Reign FC")
  end

  it '#worst_offense can find the team with lowest average number of goals scored' do
    expect(@stat_tracker.worst_offense).to eq("Utah Royals FC")
  end

  it '#highest_scoring_visitor can find the team with highest average score(away)' do
    expect(@stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
  end

  it '#highest_scoring_home_team can find the team  with highest average score(home) ' do
    expect(@stat_tracker.highest_scoring_home_team).to eq("Reign FC")
  end

  it '#lowest_scoring_visitor can find the team with lowest average score(visitor)' do
    expect(@stat_tracker.lowest_scoring_visitor).to eq("San Jose Earthquakes")
  end

  it '#lowest_scoring_home_team can find the team with lowest average score(home)' do
    expect(@stat_tracker.lowest_scoring_home_team).to eq("Utah Royals FC")
  end

  it "returns highest total score" do
    # stat_tracker = StatTracker.from_csv(@locations)
    expect(@stat_tracker.highest_total_score).to eq(11)
  end

  it "#lowest_total_score" do
    expect(@stat_tracker.lowest_total_score).to eq 0
  end

  it "#percentage_home_wins" do

    expect(@stat_tracker.percentage_home_wins).to eq 0.55

  end

  it "#percentage_visitor_wins" do
    expect(@stat_tracker.percentage_visitor_wins).to eq 0.36
  end

  it "#percentage_ties" do
    expect(@stat_tracker.percentage_ties).to eq 0.20
  end

  it "#count_of_games_by_season" do
    expected = {
      "20122013"=>806,
      "20162017"=>1317,
      "20142015"=>1319,
      "20152016"=>1321,
      "20132014"=>1323,
      "20172018"=>1355
    }
    expect(@stat_tracker.count_of_games_by_season).to eq expected
  end

  it "#average_goals_per_game" do
    expect(@stat_tracker.average_goals_per_game).to eq 4.22
  end

  it "#average_goals_by_season" do
    expected = {
      "20122013"=>4.12,
      "20162017"=>4.23,
      "20142015"=>4.14,
      "20152016"=>4.16,
      "20132014"=>4.19,
      "20172018"=>4.44
    }
    expect(@stat_tracker.average_goals_by_season).to eq expected
  end

  it "#count_of_teams" do
    expect(@stat_tracker.count_of_teams).to eq 32
  end

  it "#best_offense" do
    expect(@stat_tracker.best_offense).to eq "Reign FC"
  end

  it 'test' do
    expect(@stat_tracker.test).to eq("Dan Lacroix")

    expect(@stat_tracker.winningest_coach("20122013")).to eq("Dan Lacroix")
  end

  it "most accurate team" do
    expect(@stat_tracker.most_accurate_team("20122013")).to eq("DC United")
  end

  it "least accurate team" do
   expect(@stat_tracker.least_accurate_team("20122013")).to eq("New York City FC")
  end

  it "most tackles" do
    expect(@stat_tracker.most_tackles("20122013")).to eq("FC Cincinnati")
  end

  it "fewest tackles" do
    expect(@stat_tracker.fewest_tackles("20122013")).to eq("Atlanta United")
  end

  xit "team info" do #takes team_id as argument
    expect(@stat_tracker.team_info("20122013")).to eq() #hash
  end

  it "best season" do #takes team_id as argument
    expect(@stat_tracker.best_season("20122013")).to eq() #string
  end

  xit "worst season" do #takes team_id as argument
    expect(@stat_tracker.worst_season("20122013")).to eq() #string
  end

  xit "average win percentage" do #takes team_id as argument
    expect(@stat_tracker.average_win_percentage("20122013")).to eq() #float
  end

  xit "most goals scored" do #takes team_id as argument
    expect(@stat_tracker.most_goals_scored("20122013")).to eq() #integer
  end

  xit "fewest goals scored" do #takes team_id as argument
    expect(@stat_tracker.fewest_goals_scored("20122013")).to eq() #integer
  end

  xit "favorite opponent" do #takes team_id as argument
    expect(@stat_tracker.favorite_opponeent("20122013")).to eq() #string
  end

  xit "rival" do #takes team_id as argument
    expect(@stat_tracker.rival("20122013")).to eq() #string
  end










end
