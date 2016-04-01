def rand_gen
	1 + rand(180)
end

=begin
	points = 3 * wins + 1 * loses
	wRatio = win/win + lose
=end

10.times do |i|
	player_id = i
	actual_pid = (i + 1).to_s
	wins = rand_gen
	loses = rand_gen
	points = 3 * wins + 1 * loses
	goals = rand_gen
	wRatio = wins.fdiv(wins + loses)
	display_wRatio = sprintf "%.10f", wRatio
	pullUps = rand_gen
	
	Score.create(player_id: actual_pid, wins: wins, loses: loses, points: points, 
		goals: goals, wRatio: display_wRatio, pullUps: pullUps)
end
