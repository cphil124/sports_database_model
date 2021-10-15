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

CREATE TABLE nfl.league_conference (
    id int IDENTITY(1,1) PRIMARY KEY, 
    conference_name nvarchar(100)
);

CREATE TABLE nfl.league_division (
    id int IDENTITY(1,1) PRIMARY KEY, 
    divison_name nvarchar(100), 
    conference_id int NOT NULL,
    FOREIGN KEY (conference_id) REFERENCES nfl.league_conference(id)
);

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

CREATE TABLE nfl.office_roles (
    id int IDENTITY(1,1),
    role_title nvarchar(100) NOT NULL,
    role_description nvarchar(200) NOT NULL
);

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

CREATE TABLE nfl.league_season(
    id int IDENTITY(1,1),
    league_starting_calendar_year int NOT NULL
)

CREATE TABLE nfl.league_week_type (
    week_id int NOT NULL PRIMARY KEY,
    week_description nvarchar(100)
)

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

CREATE TABLE nfl.position_types (
    id int IDENTITY(1,1),
    positon_type nvarchar(20)
)

CREATE TABLE nfl.football_positions (
    id int IDENTITY(1,1),
    position_name nvarchar(30) NOT NULL,
    position_type_id int NOT NULL
)

CREATE TABLE nfl.player (
    id int IDENTITY(1,1),
    person_id int NOT NULL,
    active bit NOT NULL DEFAULT 1
)

CREATE TABLE nfl.team_players ( -- Need some way to account for players playing multiple positions
    id int IDENTITY(1,1),
    team_id int NOT NULL,
    player_id int NOT NULL, -- FK to player table
    jersey_number int NOT NULL,
    player_roster_position_id int NOT NULL,
    player_date_of_birth date NULL
)

CREATE TABLE nfl.player_draft ( 
    id int IDENTITY(1,1),
    player_id int NOT NULL,
    drafting_team_id int NOT NULL,
    draft_asset_id int NOT NULL,
    draft_position int NOT NULL
)

CREATE TABLE nfl.transaction_type (
    id int IDENTITY(1,1),
    type_of_transaction nvarchar(50)
)

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














































