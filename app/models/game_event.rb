class GameEvent < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  def game_time
    "#{ (timestamp / 60) + 1 }'"
  end

  def event_name
    case event_type
    when 1
      "Pass"
    when 2
      "Shot"
    when 3
      "Substitution"
    when 4
      "Shot against"
    when 5
      "Tackle"
    when 6
      "Foul"
    when 7
      "Yellow Card"
    when 8
      "Red Card"
    else
      "Undefined Event"
    end
  end

  def subtype_name
    case event_type
    when 1
      pass_subtype
    when 2
      shot_subtype
    when 3
      substitution_subtype
    when 4
      shot_against_subtype
    else
      "No subtype"
    end
  end

  def pass_subtype
    case event_subtype
    when 1
      "Complete"
    when 2
      "Incomplete"
    when 3
      "Key"
    when 4
      "Assist"
    else
      "Undefined"
    end
  end

  def shot_subtype
    case event_subtype
    when 1
      "On Target"
    when 2
      "Off Target"
    when 3
      "Goal"
    else
      "Undefined"
    end
  end

  def substitution_subtype
    case event_subtype
    when 1
      "Sub On"
    when 2
      "Sub Off"
    else
      "Undefined"
    end
  end

  def shot_against_subtype
    case event_subtype
    when 1
      "Save"
    when 2
      "Conceded"
    else
      "Undefined"
    end
  end
end
