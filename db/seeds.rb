# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def get_winner(red_goal, blue_goal)
	red_goal > blue_goal ? 'r' : 'b'
end

def rand_gen(n)
	1 + rand(n)
end

def generate_players
	players = []

	while players.count < 4
		player = rand_gen(14)
		players.include?(player) ? next : players.push(player)
	end

	players
end

# Player seeding
player_list = [
	["Toh Weiqing", "WQ"],
	["Soh Yu Ming", "SYM"],
	["Benny Ou", "BO"],
	["Brian Koh", "BK"],
	["Fong Li Heng", "FLH"],
	["Eugene Chow", "EC"],
	["Soedarsono", "SD"],
	["Evelyn Lee", "EL"],
	["Ben Leong", "BL"],
	["Luo Yanjie", "LY"],
	["Abel Tay", "AT"],
	["Chester How", "CH"],
	["Hansel Chia", "HC"],
	["Ivan Tan", "IT"]
]

player_list.each do |name, nick|
	Player.create(name: name, alias: nick)
end

# Match seeding
match_list = []

10.times do |i|

  players1 = generate_players
  players2 = generate_players

  match1 = [players1[0], players1[1], players1[2], players1[3], 10, rand_gen(9)]
  match2 = [players2[0], players2[1], players2[2], players2[3], rand_gen(9), 10]

  match_list.push(match1)
  match_list.push(match2)
end

match_list.shuffle

match_list.each_with_index do |match, index|
	Match.create(redGoal: match[4], blueGoal: match[5], winner: get_winner(match[4], match[5]))

  PlayerMatch.create(match_id: index + 1, player_id: match[0], team: 'r', position: 'atk')
	PlayerMatch.create(match_id: index + 1, player_id: match[1], team: 'r', position: 'atk')
	PlayerMatch.create(match_id: index + 1, player_id: match[2], team: 'b', position: 'def')
	PlayerMatch.create(match_id: index + 1, player_id: match[3], team: 'b', position: 'def')
end
