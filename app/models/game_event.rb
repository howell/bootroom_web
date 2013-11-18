class GameEvent < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  validates :player_id, presence: true

  include GameEventsHelper
  include GameEventTypes

  def game_time
    "#{ (timestamp / 60) + 1 }'"
  end

  def event_name
    EVENT_NAMES[event_type]
  end

  def subtype_name
    if EVENT_SUBTYPE_NAMES[event_type].nil?
      nil
    else
      EVENT_SUBTYPE_NAMES[event_type][event_subtype]
    end
  end

  def has_other_player
    !(other_player_id.blank? || other_player_id == 0)
  end

  def conceded?
    event_type == SHOT_AGAINST && event_subtype == CONCEDED
  end

  def goal_scored?
    event_type == SHOT && event_subtype == GOAL
  end

  def self.match_report(game_events)
    match_report = { }
    match_report[:passing] = passing_report(game_events)
    match_report[:shooting] = shooting_report(game_events)
    match_report[:defending] = defending_report(game_events)
    match_report
  end

  def self.passing_report(game_events)
    passing_report = { total: 0, complete: 0, incomplete: 0,
                       key: 0, assists: 0 }
    passing_events = game_events.select { |ge| ge.event_type == PASS }
    passing_events.each do |pass|
      passing_report[:total] += 1
      case pass.event_subtype
      when PASS_COMPLETE
        passing_report[:complete] += 1
      when PASS_INCOMPLETE
        passing_report[:incomplete] += 1
      when PASS_KEY
        passing_report[:key] += 1
        passing_report[:complete] += 1
      when ASSIST
        passing_report[:key] += 1
        passing_report[:complete] += 1
        passing_report[:assists] += 1
      else
      end
    end
    if passing_report[:total] == 0
      passing_report[:accuracy] = 0
    else
      passing_report[:accuracy] = (passing_report[:complete] * 100) /
        passing_report[:total]
    end
    passing_report
  end

  def self.shooting_report(game_events)
    shooting_report = { total: 0, on_target: 0, off_target: 0, goals: 0 }
    shooting_events = game_events.select { |ge| ge.event_type == SHOT }
    shooting_events.each do |shot|
      shooting_report[:total] += 1
      case shot.event_subtype
      when SHOT_ON_TARGET
        shooting_report[:on_target] += 1
      when SHOT_OFF_TARGET
        shooting_report[:off_target] += 1
      when GOAL
        shooting_report[:on_target] += 1
        shooting_report[:goals] += 1
      else
      end
    end
    if shooting_report[:total] == 0
      shooting_report[:accuracy] = 0
    else
      shooting_report[:accuracy] = (shooting_report[:on_target] * 100) /
        shooting_report[:total]
    end
    shooting_report
  end

  def self.defending_report(game_events)
    defending_report = { tackles: 0, clearances: 0, interceptions: 0 }
    defending_events = game_events.select do |ge|
      ge.event_type == TACKLE or ge.event_type == CLEARANCE or \
        ge.event_type == INTERCEPTION
    end
    defending_events.each do |ge|
      case ge.event_type
      when TACKLE
        defending_report[:tackles] += 1
      when INTERCEPTION
        defending_report[:interceptions] += 1
      when CLEARANCE
        defending_report[:clearances] += 1
      else
      end
    end
    defending_report
  end

  # From all the events for a certain player in a game, calculate the number of
  # minutes they played
  def self.playing_time(player, game = nil)
    events = nil
    if game
      events = game.game_events.select do |ge|
        ge.player_id == player.id
      end
    else
      events = player.game_events
    end
    if events.length == 0
      return 0
    end
    ordered = events.sort_by { |e| e.timestamp }
    on_the_field = false
    playing_time = 0
    last_time = 0
    if ordered[0].event_type != SUBSTITUTION
      on_the_field = true
    end
    ordered.each do |e|
      if e.event_type == SUBSTITUTION
        if e.event_subtype == SUBSTITUTION_ON
          last_time = e.timestamp
          on_the_field = true
        else
          playing_time += e.timestamp - last_time
          on_the_field = false
        end
      end
    end
    if on_the_field
      playing_time += (90 * 60) - last_time
    end
    return playing_time / 60
  end

end
