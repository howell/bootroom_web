class Game < ActiveRecord::Base
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  has_many :game_events

  def pretty_title
    "#{home_team.name} at #{away_team.name}"
  end
end
