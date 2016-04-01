# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


def rand_gen(n)
	1 + rand(n)
end

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
	["Abel Tay", "AT"]
]

player_list.each do |name, nick|
	Player.create(name: name, alias: nick)
end

5.times do |i|
	redAtt = rand_gen(11)
	redDef = rand_gen(11)
	blueAtt = rand_gen(11)
	blueDef = rand_gen(11)
	redGoal = rand_gen(10)
	blueGoal = rand_gen(10)
	winner = redGoal > blueGoal ? 0 : 1

	Match.create(redAtt: redAtt, redDef: redDef, blueAtt: blueAtt, blueDef: blueDef, 
		redGoal: redGoal, blueGoal: blueGoal, winner: winner)
end
