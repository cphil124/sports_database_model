DECLARE @tom_person_id int = (SELECT id FROM league.person WHERE first_name = 'Tom' AND last_name = 'Brady')
DECLARE @tm_id int = (SELECT id FROM team.nfl_team WHERE team_name = 'New England Patriots')
DECLARE @pos_id int = (SELECT id FROM player.football_positions WHERE position_name = 'Quarterback')
DECLARE @tom_player_id int;
DECLARE @jersey_num int = 12;

