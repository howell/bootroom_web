namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    # create teams and players
    teams = ["Wanderers", "Rovers", "Beams", "FC Foo", "Bar United", "Arsenal"]
    positions = ["GK", "LB", "RB",  "CB", "CM", "LW", "RW", "CF", "ST"]
    teams.each do |name|
      team = Team.create!(name: name, league: "tip top division")
      20.times do |n|
        name = Faker::Name.name.split
        Player.create!(first_name: name[0],
                       last_name: name[1],
                       number: n,
                       email: Faker::Internet.email(name.join),
                       team_id: team.id)
      end
    end
    # create games and events
    teams = Team.all
    20.times do |n|
      teams = teams.shuffle
      teams.each_slice(2) do |s|
        home = s[0]
        away = s[1]
        g = Game.create!(home_team_id: home.id,
                         away_team_id: away.id,
                         home_final_score: 0,
                         away_final_score: 0)
        s.each do |t|
          100.times do |m|
            ge = GameEvent.create!(timestamp: rand(90 * 60),
                                   game_id: g.id,
                                   event_type: 1 + rand(14),
                                   event_subtype: 1 + rand(5),
                                   player_id: t.players[rand(20)].id,
                                   position: positions[rand(positions.size)])
            if ge.goal_scored?
              if t == home
                g.home_final_score += 1
              else
                g.away_final_score += 1
              end
            end
          end
          g.save!
        end
      end
    end
  end
end
