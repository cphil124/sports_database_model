CREATE SCHEMA state;
DROP TABLE IF EXISTS state.state_codes;
CREATE TABLE state.state_codes (
    id int IDENTITY(1,1) PRIMARY KEY,
    state_code varchar(2) NOT NULL,
    state_name varchar(40) NOT NULL
);

CREATE SCHEMA nfl;
CREATE TABLE nfl.person ( -- Every player, coach, employee has a person record
    id int IDENTITY(1,1),
    first_name nvarchar(100) NOT NULL,
    last_name nvarchar(100) NOT NULL
);
INSERT INTO nfl.person (first_name, last_name) VALUES ('Roger', 'Goodell'), ('Robert', 'Kraft'), ('Tom', 'Brady')

CREATE TABLE nfl.league_conference (id int IDENTITY(1,1) PRIMARY KEY, conference_name nvarchar(100));
INSERT INTO nfl.league_conference ('American Football Conference'), ('National Football Conference')

CREATE TABLE nfl.league_division (
    id int IDENTITY(1,1) PRIMARY KEY, 
    divison_name nvarchar(100), 
    conference_id int NOT NULL,
    FOREIGN KEY (conference_id) REFERENCES nfl.league_conference(id)
)
INSERT INTO nfl.league_division (division_name, conference_id)
VALUES ('AFC North', 1), ('AFC West', 1), ('AFC South', 1), ('AFC East', 1),  ('NFC North', 2), ('NFC West', 2), ('NFC South', 2), ('NFC East', 2)

CREATE TABLE nfl.team (
    id int IDENTITY(1,1),
    team_name nvarchar(50) NOT NULL,
    team_abbreviation nvarchar(3) NOT NULL,
    team_region nvarchar(100) NOT NULL,
    team_hq_state_id int NOT NULL,
    team_division_id int NOT NULL,
    FOREIGN KEY (team_division_id) REFERENCES nfl.league_division(id),
    FOREIGN KEY (team_hq_state_id) REFERENCEs state.state_codes (id)
);
INSERT INTO nfl.team (team_name, team_region, team_hq_state) VALUES ('NFL', 'USA', 'NY'), ('New England Patriots', 'New England', 'MA')


CREATE TABLE nfl.office_roles (
    id int IDENTITY(1,1),
    role_title nvarchar(100) NOT NULL,
    role_description nvarchar(200) NOT NULL
);
INSERT INTO nfl.office_roles (role_title, role_description) VALUES ('Team Owner', 'Owner of an NFL Team and Franchise'), ('League Commissioner','Chief Executive Officer of the League')

CREATE TABLE nfl.office_employees (
    id int IDENTITY(1,1) PRIMARY KEY,
    team_id int NOT NULL,
    person_id int NOT NULL,
    office_role_id int NOT NULL,
    start_date date NOT NULL DEFAULT GET_DATE(),
    active bit DEFAULT = 1,
    FOREIGN KEY (team_id) REFERENCES nfl.team (id),
    FOREIGN KEY (person_id) REFERENCES nfl.person (id),
    FOREIGN KEY (office_role_id) REFERENCES nfl.office_roles (id)
);
INSERT INTO nfl.office_employees (team_id, person_id, office_role_id, start_date) 
VALUES (
    (SELECT id FROM nfl.team WHERE team_name = 'New England Patriots'),
    (SELECT id FROM nfl.person WHERE first_name = 'Robert' AND last_name = 'Kraft'),
    (SELECT id FROM nfl.job_roles WHERE role_title = 'Team Owner'),
    '1999 01 01 00:00:00.000');

CREATE TABLE nfl.team_staff_roles (
    id int IDENTITY(1,1),
    role_title nvarchar(50) NOT NULL,
    coach bit NOT NULL
)

CREATE TABLE nfl.team_coaching_staff (
    id int IDENTITY(1,1),
    team_id int NOT NULL,
    staff_role_id int NOT NULL,
    date_of_hire date NOT NULL,
    FOREIGN KEY (staff_role_id) REFERENCES 
)

CREATE TABLE nfl.season_finish_type(
    id int IDENTITY(1,1),
    finish_type nvarchar(50)
)
INSERT INTO nfl.season_finish_type (finish_type) VALUES ('Regular Season (No Postseason Appearance)'), ('Divisonal Round'), ('Wildcard Round'), ('Conference Championship Game'), ('Super Bowl Win'), ('Super Bowl Loss')

CREATE TABLE nfl.league_season(
    id int IDENTITY(1,1),
    league_starting_calendar_year int NOT NULL
)
INSERT INTO nfl.league_season (league_starting_calendar_year) VALUES (2021)

-- Week type to allow for flexibility in changing season lengths
CREATE TABLE nfl.league_week_type (
    week_id int NOT NULL PRIMARY KEY,
    week_description nvarchar(100)
)
-- INSERT INTO nfl.league_week_type(week_code, week_description)
-- VALUES (-1, 'Preseason Week 1'),(-2, 'Preseason Week 2'),(99, 'Superbowl Weekend'),(98, 'Conference Championship Weekend'), (97, 'Divisional Round Weekend'), (96, 'Wildcard Weekend'), (1, 'Week 1'), (2, 'Week 2')

CREATE TABLE nfl.league_season_week (
    id int IDENTITY(1,1) PRIMARY KEY,
    league_season int NOT NULL, -- FK to nfl.league_season (id)
    league_week_type int NOT NULL -- FK to nfl.league_week_type (id)
)


CREATE TABLE nfl.team_season (
    id int IDENTITY(1,1),
    team_id int NOT NULL,
    league_season int NOT NULL,
    win_total int NOT NULL,
    loss_total int NOT NULL,
    tie_total int NOT NULL
    season_finish_type_id int NOT NULL,
    FOREIGN KEY (season_finish_type_id) REFERENCES nfl.season_finish_type(id)
)
INSERT INTO nfl.team_season (team_id, nfl_season_id, win_total, loss_total, tie_total, season_finish_type_id) 
VALUES (
    (SELECT id FROM nfl.team WHERE team_name = 'New England Patriots'),
    (SELECT id FROM nfl.league_season WHERE league_starting_calendar_year = 2007),
    16, 
    0,
    0,
    (SELECT id FROM nfl.season_finish_type WHERE finish_type = 'Super Bowl Loss')
)

CREATE TABLE nfl.team_draft_assets (
    id int IDENTITY(1,1),
    original_team int NOT NULL,
    league_season_id int NOT NULL,
    pick_round int NOT NULL,
    compensatory bit NOT NULL DEFAULT 0
)
 
CREATE VIEW nfl.vw_advanced_team_season_results AS SELECT 1
-- calculate win pct, find home + away wins/losses, conference + division wins/losses, pcts
-- points for, points against, differential











