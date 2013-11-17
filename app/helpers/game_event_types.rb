module GameEventTypes

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
  FOULED = 15
  DISPOSSESSED = 16
  OFFSIDES = 17

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

  # Interception Sub-types
  INT_ANTICIPATION = 1
  INT_POSITIONING = 2

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
      GOAL_KICK     => "Goal Kick",
      FOULED        => "Fouled",
      DISPOSSESSED  => "Dispossessed",
      OFFSIDES      => "Offsides" }

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
                         GK_UNSUCCESSFUL  => "Unsuccessful"},
      INTERCEPTION  => { INT_POSITIONING  => "Positioning",
                         INT_ANTICIPATION => "Anticipation" } }
end
