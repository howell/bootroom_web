class GameEvent < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  validates :player_id, presence: true


  def event_names
    { 1 => "Pass",
      2 => "Shot",
      3 => "Substitution",
      4 => "Shot against",
      5 => "Tackle",
      6 => "Foul",
      7 => "Yellow Card",
      8 => "Red Card" }
  end

  def event_subtype_names
    { 1 => { 1 => "Complete", 2 => "Incomplete", 3 => "Key",
             4 => "Assist"},
      2 => { 1 => "On Target", 2 => "Off Target", 3 => "Goal" },
      3 => { 1 => "Sub On", 2 => "Sub Off" },
      4 => { 1 => "Save", 2 => "Conceded" } }
  end

  def game_time
    "#{ (timestamp / 60) + 1 }'"
  end

  def event_name
    event_names[event_type]
  end

  def subtype_name
    if event_subtype_names[event_type].nil?
      nil
    else
      event_subtype_names[event_type][event_subtype]
    end
  end

  def has_other_player
    !(other_player_id.blank? || other_player_id == 0)
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
    passing_events = game_events.select { |ge| ge.event_type == 1 }
    passing_events.each do |pass|
      passing_report[:total] += 1
      case pass.event_subtype
      when 1  # Complete
        passing_report[:complete] += 1
      when 2 # Incomplete
        passing_report[:incomplete] += 1
      when 3 # Key
        passing_report[:key] += 1
        passing_report[:complete] += 1
      when 4 # Assist
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
    shooting_events = game_events.select { |ge| ge.event_type == 2 }
    shooting_events.each do |shot|
      shooting_report[:total] += 1
      case shot.event_subtype
      when 1 # On Target
        shooting_report[:on_target] += 1
      when 2 # Off Target
        shooting_report[:off_target] += 1
      when 3 # Goal
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
    defending_report = { }
    defending_events = game_events.select { |ge| ge.event_type == 5 }
    defending_report[:tackles] = defending_events.count
    defending_report
  end
end
