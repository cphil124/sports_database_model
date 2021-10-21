CREATE SCHEMA state
GO
DROP TABLE IF EXISTS state.state_codes;
CREATE TABLE state.state_codes (
    id int IDENTITY(1,1) PRIMARY KEY,
    state_code varchar(2) NOT NULL,
    state_name varchar(40) NOT NULL
);

CREATE SCHEMA league;
DROP TABLE IF EXISTS [league].[person];
CREATE TABLE [league].[person](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[first_name] [nvarchar](100) NOT NULL,
	[last_name] [nvarchar](100) NOT NULL,
    [date_of_birth] date NOT NULL,
    [alma_mater] nvarchar(150) NULL
);
INSERT INTO league.person (first_name, last_name, date_of_birth) VALUES ('Roger', 'Goodell', '1/1/1950'), ('Robert', 'Kraft', '1/1/1933'), ('Tom', 'Brady', '1/1/1977')

DROP TABLE IF EXISTS league.conference;
CREATE TABLE league.conference (
    id int IDENTITY(1,1) PRIMARY KEY, 
    conference_name nvarchar(100) NOT NULL
);
INSERT INTO league.conference ('American Football Conference'), ('National Football Conference')

DROP TABLE IF EXISTS league.division;
CREATE TABLE league.division (
    id int IDENTITY(1,1) PRIMARY KEY, 
    division_name nvarchar(100), 
    conference_id int NOT NULL,
    FOREIGN KEY (conference_id) REFERENCES league.conference(id)
);
INSERT INTO league.division (division_name, conference_id)
VALUES ('AFC North', 1), ('AFC West', 1), ('AFC South', 1), ('AFC East', 1),  ('NFC North', 2), ('NFC West', 2), ('NFC South', 2), ('NFC East', 2)

DROP TABLE IF EXISTS league.season;
CREATE TABLE league.season(
    league_starting_calendar_year int NOT NULL PRIMARY KEY
);
INSERT INTO league.season (league_starting_calendar_year) VALUES (2021)

-- Week type to allow for flexibility in changing season lengths
DROP TABLE IF EXISTS league.week_type;
CREATE TABLE league.week_type (
    week_id int NOT NULL PRIMARY KEY,
    week_description nvarchar(100)
);
INSERT INTO league.week_type(week_code, week_description)
VALUES (-1, 'Preseason Week 1'),(-2, 'Preseason Week 2'),(99, 'Superbowl Weekend'),(98, 'Conference Championship Weekend'), (97, 'Divisional Round Weekend'), (96, 'Wildcard Weekend'), (1, 'Week 1'), (2, 'Week 2')

DROP TABLE IF EXISTS league.season_week;
CREATE TABLE league.season_week (
    id int IDENTITY(1,1) PRIMARY KEY,
    league_season int NOT NULL, -- FK to league.season (league_starting_calendar_year)
    league_week_type int NOT NULL, -- FK to league.week_type (id)
    FOREIGN KEY (league_season) REFERENCES league.season (league_starting_calendar_year),
    FOREIGN KEY (league_week_type) REFERENCES league.week_type (week_id)
);
INSERT INTO league.season_week (2021, 99); -- Superbowl 2021

DROP TABLE IF EXISTS league.stadium;
CREATE TABLE league.stadium (
    id int IDENTITY(1,1) PRIMARY KEY,
    stadium_name nvarchar(100) NOT NULL,
    city_name nvarchar(100) NOT NULL,
    state_code_id int NOT NULL,
    stadium_ownership_type_id int NOT NULL,
    year_opened int NOT NULL,
    year_closed int NOT NULL DEFAULT 9999
    FOREIGN KEY (stadium_ownership_type_id) REFERENCES team.stadium_ownership_type (id)
);
INSERT INTO league.stadium (stadium_name, city_name, stadium_ownership_id) VALUES ('Gillette Stadium', 'Foxborough', 1)
