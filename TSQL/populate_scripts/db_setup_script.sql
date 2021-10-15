-- Populate referential tables like league year/week and position types
-- state.state_codes
INSERT INTO state.state_codes (state_name, state_code)
VALUES ('Alabama', 'AL'),('Alaska', 'AK'),('Arizona', 'AZ'),('Arkansas', 'AR'),('California', 'CA'),('Colorado', 'CO'),('Connecticut', 'CT'),('Delaware', 'DE'),('District of Columbia', 'DC'),('Florida', 'FL'),('Georgia', 'GA'),('Hawaii', 'HI'),('Idaho', 'ID'),
       ('Illinois', 'IL'),('Indiana', 'IN'),('Iowa', 'IA'),('Kansas', 'KS'),('Kentucky', 'KY'),('Louisiana', 'LA'),('Maine', 'ME'),('Maryland', 'MD'),('Massachusetts', 'MA'),
       ('Michigan', 'MI'),('Minnesota', 'MN'),('Mississippi', 'MS'),('Missouri', 'MO'),('Montana', 'MT'),('Nebraska', 'NE'),('Nevada', 'NV'),('New Hampshire', 'NH'),('New Jersey', 'NJ'),('New Mexico', 'NM'),
       ('New York', 'NY'),('North Carolina', 'NC'),('North Dakota', 'ND'),('Ohio', 'OH'),('Oklahoma', 'OK'),('Oregon', 'OR'),('Pennsylvania', 'PA'),('Rhode Island', 'RI'),('South Carolina', 'SC'),
       ('South Dakota', 'SD'),('Tennessee', 'TN'),('Texas', 'TX'),('Utah', 'UT'),('Vermont', 'VT'),('Virginia', 'VA'),('Washington', 'WA'),('West Virginia', 'WV'),('Wisconsin', 'WI'),('Wyoming', 'WY'),
       ('MX', 'Mexico'), ('UK', 'United Kingdom'), ('AU', 'Australia')

-- nfl.league_conference
INSERT INTO nfl.league_conference(conference_name) VALUES ('American Football Conference'), ('National Football Conference')
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

INSERT INTO nfl.team (team_name, team_region, team_abbreviation, team_hq_state_id, team_division_id)
VALUES ('Pittsburgh Steelers', 'Pittsburgh', 'PIT',(SELECT id FROM state.state_codes WHERE state_name = 'Pennsylvania'), @afc_n)
,('Cleveland Browns', 'Cleveland', 'CLE',(SELECT id FROM state.state_codes WHERE state_name = 'Ohio'), @afc_n)
,('Cincinnati Bengals', 'Cincinnati', 'CIN',(SELECT id FROM state.state_codes WHERE state_name = 'Ohio'), @afc_n)
,('Houston Texans', 'Houston', 'HOU',(SELECT id FROM state.state_codes WHERE state_name = 'Texas'), @afc_n)
,('Indianapolis Colts', 'Indianapolis', 'IND',(SELECT id FROM state.state_codes WHERE state_name = 'Indiana'), @afc_s)
,('Jacksonville Jaguars', 'Jacksonville', 'JAX',(SELECT id FROM state.state_codes WHERE state_name = 'Florida'), @afc_s)
,('Tennessee Titans', 'Tennessee', 'TEN',(SELECT id FROM state.state_codes WHERE state_name = 'Tennessee'), @afc_s)
,('Buffalo Bills', 'Buffalo', 'BUF',(SELECT id FROM state.state_codes WHERE state_name = 'New York'), @afc_e)
,('Miami Dolphins', 'Miami', 'MIA',(SELECT id FROM state.state_codes WHERE state_name = 'Florida'), @afc_e)
,('New England Patriots', 'New England', 'NE',(SELECT id FROM state.state_codes WHERE state_name = 'Massachusetts'), @afc_e)
,('New York Jets', 'New York', 'NYJ',(SELECT id FROM state.state_codes WHERE state_name = 'New York'), @afc_e)
,('Denver Broncos', 'Denver', 'DEN',(SELECT id FROM state.state_codes WHERE state_name = 'Colorado'), @afc_w)
,('Kansas City Chiefs', 'Kansas City', 'KC',(SELECT id FROM state.state_codes WHERE state_name = 'Missouri'), @afc_w)
,('Las Vegas Raiders', 'Las Vegas', 'LV',(SELECT id FROM state.state_codes WHERE state_name = 'Nevada'), @afc_w)
,('Los Angeles Chargers', 'Los Angeles', 'LAC',(SELECT id FROM state.state_codes WHERE state_name = 'California'), @afc_w)
,('Chicago Bears', 'Chicago', 'CHI',(SELECT id FROM state.state_codes WHERE state_name = 'Illinois'), @nfc_n)
,('Detroit Lions', 'Detroit', 'DET',(SELECT id FROM state.state_codes WHERE state_name = 'Michigan'), @nfc_n)
,('Green Bay Packers', 'Green Bay', 'GB',(SELECT id FROM state.state_codes WHERE state_name = 'Wisconsin'), @nfc_n)
,('Minnesota Vikings', 'Minnesota', 'MIN',(SELECT id FROM state.state_codes WHERE state_name = 'Minnesota'), @nfc_n)
,('Atlanta Falcons', 'Atlanta', 'ATL',(SELECT id FROM state.state_codes WHERE state_name = 'Georgia'), @nfc_s)
,('Carolina Panthers', 'Carolinas', 'CAR',(SELECT id FROM state.state_codes WHERE state_name = 'North Carolina'), @nfc_s)
,('New Orleans Saints', 'New Orleans', 'NO',(SELECT id FROM state.state_codes WHERE state_name = 'Louisiana'), @nfc_s)
,('Tampa Bay Buccaneers', 'Tampa', 'TB',(SELECT id FROM state.state_codes WHERE state_name = 'Florida'), @nfc_s)
,('Dallas Cowboys', 'Dallas', 'DAL',(SELECT id FROM state.state_codes WHERE state_name = 'Texas'), @nfc_e)
,('New York Giants', 'New York', 'NYG',(SELECT id FROM state.state_codes WHERE state_name = 'New York'), @nfc_e)
,('Philadelphia Eagles', 'Philadelphia', 'PHI',(SELECT id FROM state.state_codes WHERE state_name = 'Pennsylvania'), @nfc_e)
,('Washington Football Team', 'Washington DC', 'WAS',(SELECT id FROM state.state_codes WHERE state_name = 'District of Columbia'), @nfc_e)
,('Arizona Cardinals', 'Arizona', 'ARI',(SELECT id FROM state.state_codes WHERE state_name = 'Arizona'), @nfc_w)
,('Los Angeles Rams', 'Los Angeles', 'LAR',(SELECT id FROM state.state_codes WHERE state_name = 'California'), @nfc_w)
,('San Francisco 49ers', 'San Francisco', 'SF',(SELECT id FROM state.state_codes WHERE state_name = 'California'), @nfc_w)
,('Seattle Seahawks', 'Seattle', 'SEA',(SELECT id FROM state.state_codes WHERE state_name = 'Washington'), @nfc_w)

-- nfl.season_finish_type
INSERT INTO nfl.season_finish_type (finish_type) VALUES ('Regular Season (No Postseason Appearance)'), ('Divisonal Round'), ('Wildcard Round'), ('Conference Championship Game'), ('Super Bowl Win'), ('Super Bowl Loss')

-- nfl.league_season
DECLARE @start_year int = 1920, @end_year int = 2099;
WITH gen AS (
    SELECT @start_year AS num
    UNION ALL 
    SELECT num+1 FROM gen WHERE num+1 <= @end_year
)
INSERT INTO nfl.league_season (league_starting_calendar_year)
SELECT num FROM gen OPTION (MAXRECURSION 300)


-- nfl.league_week_type
INSERT INTO nfl.league_week_type (week_id, week_description)
VALUES (-1, 'Preseason Week 1'),(-2, 'Preseason Week 2'),(-3, 'Preseason Week 3'),(-4, 'Preseason Week 4'),(-5, 'Preseason Week 5'),(-6, 'Preseason Week 6'), 
(99, 'Superbowl Weekend'),(98, 'Conference Championship Weekend'), (97, 'Divisional Round Weekend'), (96, 'Wildcard Weekend'), (81, 'NFL Championship Weekend'), (82, 'Tie-Breaker Week') -- For pre-merger championships 
(1, 'Week 1'), (2, 'Week 2'),(3, 'Week 3'), (4, 'Week 4'),(5, 'Week 5'), (6, 'Week 6'),(7, 'Week 7'), (8, 'Week 8'),(9, 'Week 9'), (10, 'Week 10'),
(11, 'Week 11'), (12, 'Week 12'),(13, 'Week 13'), (14, 'Week 14'),(15, 'Week 15'), (16, 'Week 16'),(17, 'Week 17'), (18, 'Week 18'), (19, 'Week 19')

-- nfl.league_season_week
-- Playoffs:
-- 1932 - 1966 - 1 playoff game if division winners tied, 1 championship game
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1932 AND ls.league_starting_calendar_year < 1966
AND lwt.week_id IN (81, 82)

-- 1967-69 - 2 playoff games every year. 4 teams, 2nd game being superbowl
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1965 AND ls.league_starting_calendar_year < 1970
AND lwt.week_id > 97

-- 1970-77 - 3 playoff games, divisional round, conference champs, superbowl
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1969 AND ls.league_starting_calendar_year < 1978
AND lwt.week_id > 97

-- 1978-2019 - 4 playoff games, wildcard round, divisional, conference, SB
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1977 AND ls.league_starting_calendar_year < 2022
AND lwt.week_id > 95

-- Regular Season History:
-- 1920-32: No postseason, 8 weeks
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year < 1933
AND lwt.week_id > 0 AND lwt.week_id < 9

-- 35-46: 12 weeks
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1934 AND ls.league_starting_calendar_year < 1947
AND lwt.week_id > 0 AND lwt.week_id < 13

-- 47-60 12 games, 13 weeks
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1946 AND ls.league_starting_calendar_year < 1961
AND lwt.week_id > 0 AND lwt.week_id < 14

-- 61-77 14 games+weeks
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1960 AND ls.league_starting_calendar_year < 1978 AND ls.league_starting_calendar_year <> 1966
AND lwt.week_id > 0 AND lwt.week_id < 15

-- 1966 15 weeks
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year = 1966
AND lwt.week_id > 0 AND lwt.week_id < 16


-- 78-89 16 games+weeks
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1977 AND ls.league_starting_calendar_year < 1990
AND lwt.week_id > 0 AND lwt.week_id < 17

-- 90-92 16 games, 17 weeks
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1989 AND ls.league_starting_calendar_year < 1993
AND lwt.week_id > 0 AND lwt.week_id < 18

-- 93+01 16 games, 18 weeks
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year IN (1993, 2001, 2021)
AND lwt.week_id > 0 AND lwt.week_id < 19

-- 94-2020 16 games, 17 weeks
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1993 AND ls.league_starting_calendar_year < 2021 
AND ls.league_starting_calendar_year NOT IN (1993, 2001, 2021)
AND lwt.week_id > 0 AND lwt.week_id < 18

-- Preseason:
-- xx-1960: chaos - stick 5 weeks in call it a day
-- 60-66 5 preseason weeks
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year < 1967
AND lwt.week_id < 0 AND lwt.week_id > -6

-- 67-69: 4 preseason weeks
-- 78-2019: 4 preseason games
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1977 OR ls.league_starting_calendar_year IN (1967, 1968, 1969)
AND lwt.week_id < 0 AND lwt.week_id > -5

-- 70-77: 6 preseason games
INSERT INTO nfl.league_season_week (league_season, league_week_type)
SELECT ls.league_starting_calendar_year, lwt.week_id
FROM nfl.league_season ls
CROSS JOIN nfl.league_week_type lwt
WHERE ls.league_starting_calendar_year > 1969 AND ls.league_starting_calendar_year < 1978
AND lwt.week_id < 0

-- nfl.team_season
-- nfl.team_draft_assets
-- nfl.position_types
INSERT INTO nfl.position_types (position_type) VALUES ('Offense'), ('Defense'), ('Special Teams')

-- nfl.football_positions
INSERT INTO nfl.football_positions (position_name, position_type_id) 
VALUES ('Quarterback', 1), ('Wide Receiver', 1), ('Halfback (Running Back)', 1), ('Fullback', 1), ('Center', 1), ('Offensive Guard', 1), ('Offensive Tackle', 1), ('Tight End', 1),
('Corner Back', 2), ('Defensive Tackle', 2), ('Defensive End', 2), ('Middle Linebacker', 2), ('Outside Linebacker', 2), ('Safety', 2), ('Nickelback', 2),
('Place Kicker', 3), ('Kickoff Specialist', 3), ('Punter', 3), ('Holder', 3), ('Long Snapper', 3), ('Kick Returner', 3), ('Punt Returner', 3), ('Upback', 3), ('Gunner', 3), ('Jammer', 3), 

-- nfl.transaction_type
INSERT INTO nfl.transaction_type(type_of_transaction) VALUES ('Trade'),('Release'),('Cut'), ('Waive'), ('Waive/Injury'),('Drafted')

-- nfl.stadium_ownership_type
INSERT INTO nfl.stadium_ownership_type(ownership_type) VALUES ('Owner of Team', 'Home City', 'Private Investors', 'Other')



-- nfl.team_staff_roles
INSERT INTO nfl.team_staff_roles (role_title, coach)
VALUES ('Head Coach', 1), ('Offensive Coordinator', 1), ('Defensive Coordinator', 1), ('Quarterback Coach', 1), ('Defensive Line Coach', 1),
('Linebacker Coach', 1), ('Offensive Line Coach', 1), ('Running Backs Coach', 1), ('Secondary Coach', 1), ('Special Teams Coach', 1),
('Tight Ends Coach', 1), ('Wide Receivers Coach', 1), ('Assistant Coach', 1), ('Strength And Conditioning Coach', 1), 
('Owner', 0), ('CEO', 0), ('President', 0), ('General Manager', 0), ('Director of Player Personel', 0), ('Assistant Director of Player Personel', 0), 
('Scout', 0), ('Director of Scouting', 0), ('Director of Football Operations', 0)


-- nfl.stadium
INSERT INTO nfl.stadium (stadium_name, city_name, state_code_id, year_opened, stadium_ownership_type_id)
VALUES ("Allegiant Stadium", "Paradise", (SELECT id FROM state.state_codes WHERE state_name = "Nevada"), 2020, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Arrowhead Stadium", "Kansas City", (SELECT id FROM state.state_codes WHERE state_name = "Missouri"), 1972, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("AT&T Stadium", "Arlington", (SELECT id FROM state.state_codes WHERE state_name = "Texas"), 2009, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Bank of America Stadium", "Charlotte", (SELECT id FROM state.state_codes WHERE state_name = "North Carolina"), 1996, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Caesars Superdome", "New Orleans", (SELECT id FROM state.state_codes WHERE state_name = "Louisiana"), 1975, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Mile High Stadium", "Denver", (SELECT id FROM state.state_codes WHERE state_name = "Colorado"), 2001, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("FedEx Field", "Landover", (SELECT id FROM state.state_codes WHERE state_name = "Maryland"), 1997, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("First Energy Stadium", "Cleveland", (SELECT id FROM state.state_codes WHERE state_name = "Ohio"), 1999, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Ford Field", "Detroit", (SELECT id FROM state.state_codes WHERE state_name = "Michigan"), 2002, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Gillette Stadium", "Foxborough", (SELECT id FROM state.state_codes WHERE state_name = "Massachusetts"), 2002, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Hard Rock Stadium", "Miami Gardens", (SELECT id FROM state.state_codes WHERE state_name = "Florida"), 1987, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Heinz Field", "Pittsburgh", (SELECT id FROM state.state_codes WHERE state_name = "Pennsylvania"), 2001, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Highmark Stadium", "Orchard Park", (SELECT id FROM state.state_codes WHERE state_name = "New York"), 1973, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Lambeau Field", "Green Bay", (SELECT id FROM state.state_codes WHERE state_name = "Wisconsin"), 1957, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Home City'))
,("Levi's Stadium", "Santa Clara", (SELECT id FROM state.state_codes WHERE state_name = "California"), 2014, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Lincoln Financial Field", "Philadelphia", (SELECT id FROM state.state_codes WHERE state_name = "Pennsylvania"), 2003, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Lucas Oil Stadium", "Indianapolis", (SELECT id FROM state.state_codes WHERE state_name = "Indiana"), 2008, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Lumen Field", "Seattle", (SELECT id FROM state.state_codes WHERE state_name = "Washington"), 2002, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("M&T Bank Stadium", "Baltimore", (SELECT id FROM state.state_codes WHERE state_name = "Maryland"), 1998, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Mercedes-Benz Stadium", "Atlanta", (SELECT id FROM state.state_codes WHERE state_name = "Georgia"), 2017, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("MetLife Stadium", "East Rutherford", (SELECT id FROM state.state_codes WHERE state_name = "New Jersey"), 2010, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Nissan Stadium", "Nashville", (SELECT id FROM state.state_codes WHERE state_name = "Tennessee"), 1999, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("NRG Stadium", "Houston", (SELECT id FROM state.state_codes WHERE state_name = "Texas"), 2002, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Paul Brown Stadium", "Cincinnati", (SELECT id FROM state.state_codes WHERE state_name = "Ohio"), 2000, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Raymond James Stadium", "Tampa", (SELECT id FROM state.state_codes WHERE state_name = "Florida"), 1998, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("SoFi Stadium", "Inglewood", (SELECT id FROM state.state_codes WHERE state_name = "California"), 2020, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Soldier Field", "Chicago", (SELECT id FROM state.state_codes WHERE state_name = "Illinois"), 1924, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("State Farm Stadium", "Glendale", (SELECT id FROM state.state_codes WHERE state_name = "Arizona"), 2006, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("TIAA Bank Field", "Jacksonville", (SELECT id FROM state.state_codes WHERE state_name = "Florida"), 1995, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("U.S. Bank Stadium", "Minneapolis", (SELECT id FROM state.state_codes WHERE state_name = "Minnesota"), 2016, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Estadio Azteca", "Mexico City", (SELECT id FROM state.state_codes WHERE state_name = "Mexico"), 1966, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Tom Benson Hall of Fame Stadium", "Canton", (SELECT id FROM state.state_codes WHERE state_name = "Ohio"), 1938, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Wembley Stadium", "London", (SELECT id FROM state.state_codes WHERE state_name = "United Kingdom"), 2007, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))
,("Tottenham Hotspur Stadium", (SELECT id FROM state.state_codes WHERE state_name = "United Kingdom"), 2019, (SELECT id FROM nfl.stadium_ownership_type WHERE ownership_type = 'Owner of Team'))

INSERT INTO nfl.team_stadium (stadium_id, team_id, active)
VALUES ((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)
,((SELECT id FROM nfl.stadium WHERE stadium_name = ''), (SELECT id FROM nfl.team WHERE team_name = ''),1)






















