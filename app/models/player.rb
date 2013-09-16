class Player < ActiveRecord::Base
  belongs_to :team
  has_many :game_events
  # Save everything as lowercase
  before_save do
    self.first_name = first_name.downcase
    self.last_name = last_name.downcase
    self.email = email.downcase
  end

  def full_name
    first_name.capitalize + " " + last_name.capitalize
  end
end
