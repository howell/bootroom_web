class LeadersController < ApplicationController
  def show
    @Team = Team.find(params[:id])
    if params[:game_id]
      @Events = Game.find(params[:game_id]).game_events
    else
      @Events = @Team.home_games.collect { |g| g.game_events }
      @Events << @Team.away_games.collect { |g| g.game_events }
      @Events.flatten!
    end
    leaderboard = { passes_complete: { }, pass_accuracy: { }, assists: { },
                     chances_created: { }, shots: { }, shots_on_target: { },
                     shooting_accuracy: { }, goals: { }, tackles: { },
                     interceptions: { }, clearances: { }, minutes: { } }
    @Team.players.each do |p|
      events = @Events.select { |e| e.player_id == p.id }
      events.sort_by! { |e| e.timestamp }
      match_report = GameEvent::match_report(events)
      leaderboard[:passes_complete][p] = match_report[:passing][:complete]
      leaderboard[:pass_accuracy][p] = match_report[:passing][:accuracy]
      leaderboard[:assists][p] = match_report[:passing][:assists]
      leaderboard[:chances_created][p] = match_report[:passing][:key]
      leaderboard[:shots][p] = match_report[:shooting][:total]
      leaderboard[:shots_on_target][p] = match_report[:shooting][:on_target]
      leaderboard[:shooting_accuracy][p] = match_report[:shooting][:accuracy]
      leaderboard[:goals][p] = match_report[:shooting][:goals]
      leaderboard[:tackles][p] = match_report[:defending][:tackles]
      leaderboard[:interceptions][p] =match_report[:defending][:interceptions]
      leaderboard[:clearances][p] = match_report[:defending][:clearances]
      leaderboard[:minutes][p] = 0 # TODO
    end
    @Leaders = { }
    leaderboard.each do |k, v|
      arr = v.to_a.sort_by { |a| a[1] }.reverse
      @Leaders[k] = arr
    end
  end
end
