# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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

# Player seeding
player_list.each do |name, nick|
	Player.create(name: name, alias: nick)
end
