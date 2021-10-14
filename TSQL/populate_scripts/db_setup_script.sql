-- Populate referential tables like league year/week and position types
-- state.state_codes
INSERT INTO state.state_codes (state_name, state_code)
VALUES ('Alabama', 'AL'),('Alaska', 'AK'),('Arizona', 'AZ'),('Arkansas', 'AR'),('California', 'CA'),('Colorado', 'CO'),('Connecticut', 'CT'),('Delaware', 'DE'),('District of Columbia', 'DC'),('Florida', 'FL'),('Georgia', 'GA'),('Hawaii', 'HI'),('Idaho', 'ID'),
       ('Illinois', 'IL'),('Indiana', 'IN'),('Iowa', 'IA'),('Kansas', 'KS'),('Kentucky', 'KY'),('Louisiana', 'LA'),('Maine', 'ME'),('Maryland', 'MD'),('Massachusetts', 'MA'),
       ('Michigan', 'MI'),('Minnesota', 'MN'),('Mississippi', 'MS'),('Missouri', 'MO'),('Montana', 'MT'),('Nebraska', 'NE'),('Nevada', 'NV'),('New Hampshire', 'NH'),('New Jersey', 'NJ'),('New Mexico', 'NM'),
       ('New York', 'NY'),('North Carolina', 'NC'),('North Dakota', 'ND'),('Ohio', 'OH'),('Oklahoma', 'OK'),('Oregon', 'OR'),('Pennsylvania', 'PA'),('Rhode Island', 'RI'),('South Carolina', 'SC'),
       ('South Dakota', 'SD'),('Tennessee', 'TN'),('Texas', 'TX'),('Utah', 'UT'),('Vermont', 'VT'),('Virginia', 'VA'),('Washington', 'WA'),('West Virginia', 'WV'),('Wisconsin', 'WI'),('Wyoming', 'WY')

-- nfl.league_conference
INSERT INTO nfl.league_conference ('American Football Conference'), ('National Football Conference')
-- nfl.league_division
DECLARE @afc_id int, @nfc_id int;
-- DECLARE @nfc_id int;
SET @afc_id = (SELECT id FROM nfl.league_conference WHERE conference = 'American Football Conference')
SET @nfc_id = (SELECT id FROM nfl.league_conference WHERE conference = 'National Football Conference')
INSERT INTO nfl.league_division (division_name, conference_id)
VALUES ('AFC North', @afc_id), ('AFC West', @afc_id), ('AFC South', @afc_id), ('AFC East', @afc_id),  ('NFC North', @nfc_id), ('NFC West', @nfc_id), ('NFC South', @nfc_id), ('NFC East', @nfc_id)

-- nfl.team
DECLARE @afc_n int, @afc_s int, @afc_e int, @afc_w int, @nfc_n int, @nfc_s int, @nfc_e int, @nfc_w int;
SET @afc_n = (SELECT id FROM nfl.league_division WHERE division_name = 'AFC North')
SET @afc_s = (SELECT id FROM nfl.league_division WHERE division_name = 'AFC South')
SET @afc_e = (SELECT id FROM nfl.league_division WHERE division_name = 'AFC East')
SET @afc_w = (SELECT id FROM nfl.league_division WHERE division_name = 'AFC West')
SET @nfc_n = (SELECT id FROM nfl.league_division WHERE division_name = 'NFC North')
SET @nfc_s = (SELECT id FROM nfl.league_division WHERE division_name = 'NFC South')
SET @nfc_e = (SELECT id FROM nfl.league_division WHERE division_name = 'NFC East')
SET @nfc_w = (SELECT id FROM nfl.league_division WHERE division_name = 'NFC West')

INSERT INTO nfl.team (team_name, team_region, team_abbreviation, team_hq_statecode_id, team_division_id)
VALUES ('', '', '',(SELECT id FROM state.state_codes WHERE state_name = ''), @afc_n)

-- nfl.season_finish_type
INSERT INTO nfl.season_finish_type (finish_type) VALUES ('Regular Season (No Postseason Appearance)'), ('Divisonal Round'), ('Wildcard Round'), ('Conference Championship Game'), ('Super Bowl Win'), ('Super Bowl Loss')

-- nfl.league_season
DECLARE start_year int = 1920, end_year int = 2099;
WITH gen AS (
    SELECT @start_year AS num
    UNION ALL 
    SELECT num+1 FROM gen WHERE num+1 <= @end_year
)
INSERT INTO nfl.league_season (league_starting_calendar_year)
SELECT num FROM gen OPTION (MAXRECURSION 300)


-- nfl.league_week_type
INSERT INTO nfl.league_week_type (week_id, week_description)
VALUES (-1, 'Preseason Week 1'),(-2, 'Preseason Week 2'),(-3, 'Preseason Week 3'),(-4, 'Preseason Week 4'),(-5, 'Preseason Week 5'),(-5, 'Preseason Week 5'), 
(99, 'Superbowl Weekend'),(98, 'Conference Championship Weekend'), (97, 'Divisional Round Weekend'), (96, 'Wildcard Weekend'), (95, 'NFL Championship Weekend'), (94, 'Tie-Breaker Week') -- For pre-merger championships 
(1, 'Week 1'), (2, 'Week 2'),(3, 'Week 3'), (4, 'Week 4'),(5, 'Week 5'), (6, 'Week 6'),(7, 'Week 7'), (8, 'Week 8'),(9, 'Week 9'), (10, 'Week 10'),
(11, 'Week 11'), (12, 'Week 12'),(13, 'Week 13'), (14, 'Week 14'),(15, 'Week 15'), (16, 'Week 16'),(17, 'Week 17'), (18, 'Week 18'), (19, 'Week 19')

-- nfl.league_season_week

-- 1932 - 1966 - 1 playoff game if division winners tied, 1 championship game
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1932 AND ls.league_starting_calendar_year < 1967
AND lwt.week_id IN (94, 95)

-- 1967-69 - 2 playoff games every year. 4 teams, 2nd game being superbowl
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1966 AND ls.league_starting_calendar_year < 1970
AND lwt.week_id > 97

-- 1970-77 - 3 playoff games, divisional round, conference champs, superbowl
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1969 AND ls.league_starting_calendar_year < 1978
AND lwt.week_id > 97

-- 1978-2019 - 4 playoff games, wildcard round, divisional, conference SB
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1969 AND ls.league_starting_calendar_year < 1978
AND lwt.week_id > 95

-- Regular Season History:
-- 1920-32: No postseason, 8 weeks
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year < 1933
AND lwt.week_id > 0 AND lwt.week_id < 9

--35-36: 12 games
-- 37-42 11 games, 12 weeks
-- 43-45 10 games, 12 weeks
-- 46 11 games, 12 weeks
-- 47-60 12 games, 13 weeks
-- 61-77 14 games+weeks
-- 78-89 16 games+weeks
-- 90-92 16 games, 17 weeks
-- 93+01 16 games, 18 weeks
-- 94-2020 16 games, 17 weeks
-- 2021- 17 games, 18 weeks

-- Preseason:
-- xx-1960: chaos - stick 5 weeks in call it a day
-- 60-66 5 preseason weeks
-- 67-69: 4 preseason weeks
-- 70-77: 6 preseason games
-- 78-2019: 4 preseason games

-- nfl.team_season
-- nfl.team_draft_assets
-- nfl.position_types
-- nfl.football_positions
-- nfl.transaction_type
-- nfl.stadium_ownership_type
-- nfl.stadium
-- nfl.team_staff_roles




































