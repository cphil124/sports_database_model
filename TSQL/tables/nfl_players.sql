CREATE TABLE nfl.position_types (
    id int IDENTITY(1,1),
    positon_type nvarchar(20)
)
INSERT INTO nfl.position_types (position_type) VALUES ('Offense'), ('Defense'), ('Special Teams')

CREATE TABLE nfl.football_positions (
    id int IDENTITY(1,1),
    position_name nvarchar(30) NOT NULL,
    position_type_id int NOT NULL
)
INSERT INTO nfl.football_positions (position_name, position_type_id) VALUES ('Quarterback', 1), ('Wide Receiver', 1), ('Running Back', 1), ('Corner Back', 2), ('Place Kicker', 3)

CREATE TABLE nfl.player (
    id int IDENTITY(1,1),
    person_id int NOT NULL,
    active bit NOT NULL DEFAULT 1
)
INSERT INTO nfl.player (person_id, active) VALUES ((SELECT id FROM nfl.player pl INNER JOIN nfl.person per ON per.id = pl.person_id WHERE per.first_name = 'Tom' AND last_name = 'Brady'), 1)

CREATE TABLE nfl.team_players ( -- Need some way to account for players playing multiple positions
    id int IDENTITY(1,1),
    team_id int NOT NULL,
    player_id int NOT NULL, -- FK to player table
    jersey_number int NOT NULL,
    player_roster_position_id int NOT NULL,
    player_date_of_birth date NULL
)
INSERT INTO nfl.team_players (team_id, player_id, jersey_number, player_primary_position_id)
VALUES ((SELECT id FROM nfl.player WHERE person_id = 3), (SELECT id FROM nfl.team WHERE team_name = 'New England Patriots'), 12, 1)

CREATE TABLE nfl.player_draft ( 
    id int IDENTITY(1,1),
    player_id int NOT NULL,
    drafting_team_id int NOT NULL,
    draft_asset_id int NOT NULL,
    draft_position int NOT NULL
)
INSERT INTO nfl.player_draft (player_id, drafting_team_id, draft_season, draft_position, draft_round)
VALUES (
    (SELECT id FROM nfl.player pl INNER JOIN nfl.person per ON per.id = pl.person_id WHERE per.first_name = 'Tom' AND last_name = 'Brady'), 
    (SELECT id FROM nfl.team WHERE team_name = 'New England Patriots'), 
    (SELECT id FROM nfl.team_draft_assets tda 
        INNER JOIN nfl.league_season ls 
            ON tda.league_season_id = ls.league_starting_calendar_year 
        INNER JOIN nfl.team t 
            ON t.id = tda.original_team  
        WHERE league_starting_calendar_year = 2001 
        AND team_name = 'New England Patriots'
    ), 
    199)

CREATE TABLE nfl.transaction_type (
    id int IDENTITY(1,1),
    type_of_transaction nvarchar(50)
)
INSERT INTO nfl.transaction_type(type_of_transaction) VALUES ('Trade'),('Release'),('Cut'), ('Waive'), ('Waive/Injury'),('Drafted')

CREATE TABLE nfl.player_transaction (
    id int IDENTITY(1,1),
    player_id int NOT NULL, 
    transaction_type int NOT NULL,
    original_team int NOT NULL, --id of 0 used heare for league front office when adding a draft record 
    destination_team int NOT NULL, -- id of 0 here for if cut, or released. If waived, implies clearing waivers, and is indicative in all cases of free agency
    date_of_transaction date NOT NULL
)

CREATE TABLE nfl.trade_log (
    id int IDENTITY(1,1),
    date_trade_finalized date NOT NULL
)

CREATE TABLE nfl.trade_asset_transfer (
    id int IDENTITY(1,1),
    trade_id int NOT NULL,
    source_team_id int NOT NULL,
    player_asset_id int NULL,
    draft_asset_id int NULL,
    destination_team_id int NOT NULL
)