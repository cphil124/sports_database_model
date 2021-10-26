CREATE SCHEMA player;
DROP TABLE IF EXISTS player.position_types;
CREATE TABLE player.position_types (
    id int IDENTITY(1,1) PRIMARY KEY,
    position_type nvarchar(20)
);
INSERT INTO player.position_types (position_type) VALUES ('Offense'), ('Defense'), ('Special Teams');

DROP TABLE IF EXISTS player.football_positions;
CREATE TABLE player.football_positions (
    id int IDENTITY(1,1) PRIMARY KEY,
    position_name nvarchar(30) NOT NULL,
    position_abbreviation nvarchar(3) NOT NULL,
    position_type_id int NOT NULL,
	FOREIGN KEY (position_type_id) REFERENCES player.position_types (id)
);
INSERT INTO player.football_positions (position_name, position_type_id) VALUES ('Quarterback', 1), ('Wide Receiver', 1), ('Running Back', 1), ('Corner Back', 2), ('Place Kicker', 3)

DROP TABLE IF EXISTS player.player;
CREATE TABLE player.player (
    id int IDENTITY(1,1) PRIMARY KEY,
    person_id int NOT NULL,
    active bit NOT NULL DEFAULT 1,
	FOREIGN KEY (person_id) REFERENCES league.person (id)
);
INSERT INTO player.player (person_id, active) VALUES ((SELECT id FROM nfl.player pl INNER JOIN nfl.person per ON per.id = pl.person_id WHERE per.first_name = 'Tom' AND last_name = 'Brady'), 1)

DROP TABLE IF EXISTS player.player_draft;
CREATE TABLE player.player_draft ( 
    id int IDENTITY(1,1) PRIMARY KEY,
    league_season int NOT NULL,
    player_id int NOT NULL,
    drafting_team_id int NOT NULL,
    draft_asset_id int NOT NULL,
    draft_position_id int NOT NULL,
	FOREIGN KEY (player_id) REFERENCES player.player (id),
	FOREIGN KEY (drafting_team_id) REFERENCES team.nfl_team (id),
    FOREIGN KEY (draft_asset_id) REFERENCES team.draft_asset (id),
	FOREIGN KEY (league_season) REFERENCES league.season ([league_starting_calendar_year]),
    FOREIGN KEY (draft_position_id) REFERENCES player.football_positions (id)
)
INSERT INTO player.player_draft (player_id, drafting_team_id, draft_season, draft_position, draft_round)
VALUES (
    (SELECT id FROM player.player pl INNER JOIN nfl.person per ON per.id = pl.person_id WHERE per.first_name = 'Tom' AND last_name = 'Brady'), 
    (SELECT id FROM team.nfl_team WHERE team_name = 'New England Patriots'), 
    (SELECT id FROM team.draft_assets tda 
        INNER JOIN league.season ls 
            ON tda.league_season_id = ls.league_starting_calendar_year 
        INNER JOIN team.nfl_team t 
            ON t.id = tda.original_team  
        WHERE league_starting_calendar_year = 2001 
        AND team_name = 'New England Patriots'), 
    199)

DROP TABLE IF EXISTS player.transaction_type;
CREATE TABLE player.transaction_type (
    id int IDENTITY(1,1) PRIMARY KEY,
    type_of_transaction nvarchar(50) NOT NULL
);
INSERT INTO player.transaction_type(type_of_transaction) VALUES ('Trade'),('Release'),('Cut'), ('Waive'),('Waive/Injury'),('Drafted')

DROP TABLE IF EXISTS player.player_transaction;
CREATE TABLE player.player_transaction (
    id int IDENTITY(1,1) PRIMARY KEY,
    player_id int NOT NULL, 
    transaction_type int NOT NULL,
    original_team int NOT NULL, --id of 0 used heare for league front office when adding a draft record 
    destination_team int NOT NULL DEFAULT 0, -- id of 0 here for if cut, or released. If waived, implies clearing waivers, and is indicative in all cases of free agency
    date_of_transaction date NOT NULL,
    FOREIGN KEY (player_id) REFERENCES player.player (id),
    FOREIGN KEY (transaction_type) REFERENCES player.transaction_type (id),
    FOREIGN KEY (original_team) REFERENCES team.nfl_team (id),
    FOREIGN KEY (destination_team) REFERENCES team.nfl_team (id)
);