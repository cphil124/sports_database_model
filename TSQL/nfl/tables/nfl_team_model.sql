CREATE SCHEMA team;
DROP TABLE IF EXISTS team.nfl_team;
CREATE TABLE team.nfl_team (
    id int IDENTITY(1,1) PRIMARY KEY,
    team_name nvarchar(50) NOT NULL,
    team_abbreviation nvarchar(3) NOT NULL,
    team_region nvarchar(100) NOT NULL,
    team_hq_state_id int NOT NULL,
    team_division_id int NOT NULL,
    FOREIGN KEY (team_division_id) REFERENCES league.division(id),
    FOREIGN KEY (team_hq_state_id) REFERENCEs state.state_codes (id)
);
INSERT INTO team.nfl_team (team_name, team_region, team_hq_state) 
VALUES ('NFL', 'NFL', 'USA', 'NY'), ('New England Patriots', 'NE', 'New England', 'MA')


DROP TABLE IF EXISTS team.staff_roles;
CREATE TABLE team.staff_roles (
    id int IDENTITY(1,1) PRIMARY KEY,
    role_title nvarchar(50) NOT NULL,
    coach bit NOT NULL
);

DROP TABLE IF EXISTS team.staff_personel; 
CREATE TABLE team.staff_personel (
    id int IDENTITY(1,1) PRIMARY KEY,
    person_id int NOT NULL,
    team_id int NOT NULL,
    staff_role_id int NOT NULL,
    date_of_hire date NOT NULL,
    active bit DEFAULT 1,
    FOREIGN KEY (person_id) REFERENCES league.person (id),
    FOREIGN KEY (staff_role_id) REFERENCES team.staff_roles (id)
);

DROP TABLE IF EXISTS team.season_finish_type;
CREATE TABLE team.season_finish_type(
    id int IDENTITY(1,1) PRIMARY KEY,
    finish_type nvarchar(50) NOT NULL
);
INSERT INTO team.season_finish_type (finish_type) VALUES ('Regular Season (No Postseason Appearance)'), ('Divisonal Round'), ('Wildcard Round'), ('Conference Championship Game'), ('Super Bowl Win'), ('Super Bowl Loss')

DROP TABLE IF EXISTS team.season;
CREATE TABLE team.season (
    id int IDENTITY(1,1) PRIMARY KEY,
    team_id int NOT NULL,
    league_season int NOT NULL,
    win_total int NOT NULL,
    loss_total int NOT NULL,
    tie_total int NOT NULL
    season_finish_type_id int NOT NULL,
    FOREIGN KEY (season_finish_type_id) REFERENCES team.season_finish_type (id)
);
INSERT INTO team.team_season (team_id, nfl_season_id, win_total, loss_total, tie_total, season_finish_type_id) 
VALUES (
    (SELECT id FROM team.team WHERE team_name = 'New England Patriots'),
    (SELECT id FROM league.season WHERE league_starting_calendar_year = 2007),
    16, 
    0,
    0,
    (SELECT id FROM team.season_finish_type WHERE finish_type = 'Super Bowl Loss')
);

DROP TABLE IF EXISTS team.draft_asset;
CREATE TABLE team.draft_asset (
    id int IDENTITY(1,1) PRIMARY KEY,
    owner_team_id int NOT NULL,
    original_team_id int NOT NULL,
    league_season int NOT NULL,
    pick_round int NOT NULL,
    pick_player_id int NULL,
    pick_position int NULL,
    compensatory bit NOT NULL DEFAULT 0,
    used bit NOT NULL DEFAULT 0,
    FOREIGN KEY (original_team_id) REFERENCES team.nfl_team (id),
    FOREIGN KEY (owner_team_id) REFERENCES team.nfl_team (id),
    FOREIGN KEY (pick_player_id) REFERENCES player.player (id),
    FOREIGN KEY (league_season) REFERENCES league.season (league_starting_calendar_year)
);
 
DROP TABLE IF EXISTS team.roster;
CREATE TABLE team.roster ( 
    id int IDENTITY(1,1) PRIMARY KEY,
    team_id int NOT NULL,
    player_id int NOT NULL,
    jersey_number int NOT NULL,
    FOREIGN KEY (player_roster_position_id) REFERENCES player.football_positions (id),
	FOREIGN KEY (player_id) REFERENCES player.player (id)
);
INSERT INTO team.roster (team_id, player_id, jersey_number, player_primary_position_id)
VALUES ((SELECT id FROM player.player WHERE person_id = 3), (SELECT id FROM team.nfl_team WHERE team_name = 'New England Patriots'), 12, 1)

DROP TABLE IF EXISTS team.roster_positions;
CREATE TABLE team.roster_positions (
    id int IDENTITY(1,1) PRIMARY KEY,
    roster_id int NOT NULL,
    football_position_id int NOT NULL,
    FOREIGN KEY (roster_id) REFERENCES team.roster (id),
    FOREIGN KEY (football_position_id) REFERENCES player.football_positions (id)

)

DROP TABLE IF EXISTS team.stadium_ownership_type;
CREATE TABLE team.stadium_ownership_type(
    id int IDENTITY(1,1) PRIMARY KEY,
    ownership_type nvarchar(200)
);
INSERT INTO team.stadium_ownership_type(ownership_type) VALUES ('Owner of Team', 'Home City', 'Private Investors', 'Other')

DROP TABLE IF EXISTS team.home_stadium;
CREATE TABLE team.home_stadium (
    team_id int NOT NULL,
    stadium_id int NOT NULL,
    active bit DEFAULT 0,
    FOREIGN KEY (team_id) REFERENCES team.nfl_team (id),
    FOREIGN KEY (stadium_id) REFERENCES league.stadium (id),
)

DROP TABLE IF EXISTS team.trade_log;
CREATE TABLE team.trade_log (
    id int IDENTITY(1,1) PRIMARY KEY,
    league_season int NOT NULL,
    date_trade_finalized date NOT NULL,
    FOREIGN KEY (league_season) REFERENCES league.season (league_starting_calendar_year)
)
GO;
INSERT INTO team.trade_log (date_trade_finalized) VALUES ('1/1/2001');

DROP TABLE IF EXISTS team.trade_asset_transfer;
CREATE TABLE team.trade_asset_transfer (
    id int IDENTITY(1,1) PRIMARY KEY,
    trade_id int NOT NULL,
    source_team_id int NOT NULL,
    person_asset_id int NULL,
    draft_asset_id int NULL,
    destination_team_id int NOT NULL,
    FOREIGN KEY (trade_id) REFERENCES team.trade_log (id),
    FOREIGN KEY (source_team_id) REFERENCES team.nfl_team (id),
    FOREIGN KEY (destination_team_id) REFERENCES team.nfl_team (id),
    FOREIGN KEY (draft_asset_id) REFERENCES team.draft_asset (id),
    FOREIGN KEY (person_asset_id) REFERENCES league.person (id)
);
INSERT INTO team.trade_log (trade_id, source_team_id, draft_asset_id, destination_team_id) 
VALUES (1, 1, 1, 1, 1);