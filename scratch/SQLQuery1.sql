
DROP TABLE IF EXISTS player.position_types;
CREATE TABLE player.position_types (
    id int IDENTITY(1,1) PRIMARY KEY,
    positon_type nvarchar(20)
);

DROP TABLE IF EXISTS player.football_positions;
CREATE TABLE player.football_positions (
    id int IDENTITY(1,1),
    position_name nvarchar(30) NOT NULL,
    position_type_id int NOT NULL,
	FOREIGN KEY (position_type_id) REFERENCES player.position_types (id)
);

DROP TABLE IF EXISTS player.player;
CREATE TABLE player.player (
    id int IDENTITY(1,1) PRIMARY KEY ,
    person_id int NOT NULL,
    active bit NOT NULL DEFAULT 1,
	FOREIGN KEY (person_id) REFERENCES nfl.person (id)
)

DROP TABLE IF EXISTS player.team_player;
CREATE TABLE player.team_player ( -- Need some way to account for players playing multiple positions
    id int IDENTITY(1,1) PRIMARY KEY,
    team_id int NOT NULL,
    player_id int NOT NULL, -- FK to player table
    jersey_number int NOT NULL,
    player_roster_position_id int NOT NULL,
    player_date_of_birth date NULL,
	FOREIGN KEY (player_id) REFERENCES player.player (id)
)

DROP TABLE IF EXISTS player.player_draft;
CREATE TABLE player.player_draft ( 
    id int IDENTITY(1,1) PRIMARY KEY,
    player_id int NOT NULL,
    drafting_team_id int NOT NULL,
    draft_asset_id int NOT NULL,
    draft_position int NOT NULL,
	FOREIGN KEY (player_id) REFERENCES player.player (id),
	FOREIGN KEY (drafting_team_id) REFERENCES team.nfl_team (id),
    FOREIGN KEY (draft_asset_id) REFERENCES team.draft_asset (id)
)

DROP TABLE IF EXISTS player.transaction_type;
CREATE TABLE player.transaction_type (
    id int IDENTITY(1,1) PRIMARY KEY,
    type_of_transaction nvarchar(50) NOT NULL
)

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
)

DROP TABLE IF EXISTS player.trade_asset_transfer;
CREATE TABLE player.trade_asset_transfer (
    id int IDENTITY(1,1),
    trade_id int NOT NULL,
    source_team_id int NOT NULL,
	personel_id int NULL,
    player_asset_id int NULL,
    draft_asset_id int NULL,
    destination_team_id int NOT NULL,
	FOREIGN KEY (source_team_id) REFERENCES player.player (id),
	FOREIGN KEY (personel_id) REFERENCES player.player (id),
	FOREIGN KEY (player_asset_id) REFERENCES player.player (id),
)





















