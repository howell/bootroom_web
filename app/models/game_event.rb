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
end
