class GameEvent < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  validates :player_id, presence: true

  # Primary Types
  PASS = 1
  SHOT = 2
  SUBSTITUTION = 3
  SHOT_AGAINST = 4
  TACKLE = 5
  FOUL = 6
  YELLOW_CARD = 7
  RED_CARD = 8
  INTERCEPTION = 9
  CLEARANCE = 10
  DRIBBLE = 11
  GK_COLLECT = 12
  PUNT = 13
  GOAL_KICK = 14

  # Pass Sub-Types
  PASS_COMPLETE = 1
  PASS_INCOMPLETE = 2
  PASS_KEY = 3
  ASSIST = 4

  # Shot Sub-Types
  SHOT_ON_TARGET = 1
  SHOT_OFF_TARGET = 2
  GOAL = 3

  # Substitution Sub-Types
  SUBSTITUTION_ON = 1
  SUBSTITUTION_OFF = 2

  # Shot-Against Sub-Types
  SAVE = 1
  CONCEDED = 2

  # Goalkeeper event Sub-Types
  GK_SUCCESSFUL = 1
  GK_UNSUCCESSFUL = 2

  # for events where there is no other player
  NONE = 0

  EVENT_NAMES = {
      PASS          => "Pass",
      SHOT          => "Shot",
      SUBSTITUTION  => "Substitution",
      SHOT_AGAINST  => "Shot against",
      TACKLE        => "Tackle",
      FOUL          => "Foul",
      YELLOW_CARD   => "Yellow Card",
      RED_CARD      => "Red Card",
      INTERCEPTION  => "Interception",
      CLEARANCE     => "Clearance",
      DRIBBLE       => "Dribble",
      GK_COLLECT    => "Collect a cross",
      PUNT          => "Punt",
      GOAL_KICK     => "Goal Kick" }

  EVENT_SUBTYPE_NAMES =
    { PASS          => { PASS_COMPLETE    => "Complete",
                         PASS_INCOMPLETE  => "Incomplete",
                         PASS_KEY         => "Key",
                         ASSIST           => "Assist"},
      SHOT          => { SHOT_ON_TARGET   => "On Target",
                         SHOT_OFF_TARGET  => "Off Target",
                         GOAL             => "Goal" },
      SUBSTITUTION  => { SUBSTITUTION_ON  => "Sub On",
                        SUBSTITUTION_OFF  => "Sub Off" },
      SHOT_AGAINST  => { SAVE             => "Save",
                        CONCEDED          => "Conceded" },
      GK_COLLECT    => { GK_SUCCESSFUL    => "Successful",
                         GK_UNSUCCESSFUL  => "Unsuccessful"},
      PUNT          => { GK_SUCCESSFUL    => "Successful",
                         GK_UNSUCCESSFUL  => "Unsuccessful"},
      GOAL_KICK     => { GK_SUCCESSFUL    => "Successful",
                         GK_UNSUCCESSFUL  => "Unsuccessful"} }

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
end
