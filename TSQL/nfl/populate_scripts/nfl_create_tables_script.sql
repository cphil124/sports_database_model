USE master
GO

DROP DATABASE IF EXISTS nfl
GO

CREATE DATABASE nfl
GO

USE nfl
GO

CREATE SCHEMA state
GO
CREATE SCHEMA league
GO
CREATE SCHEMA player
GO
CREATE SCHEMA team
GO
CREATE SCHEMA [stats]
GO

DROP TABLE IF EXISTS state.state_codes;
CREATE TABLE state.state_codes (
    id int IDENTITY(1,1) PRIMARY KEY,
    state_code varchar(2) NOT NULL,
    state_name varchar(40) NOT NULL
)
GO


DROP TABLE IF EXISTS [league].[person];
CREATE TABLE [league].[person](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[first_name] [nvarchar](100) NOT NULL,
	[last_name] [nvarchar](100) NOT NULL,
    [date_of_birth] date NOT NULL,
    [alma_mater] nvarchar(150) NULL
)
GO

DROP TABLE IF EXISTS league.conference;
CREATE TABLE league.conference (
    id int IDENTITY(1,1) PRIMARY KEY, 
    conference_name nvarchar(100) NOT NULL
)
GO

DROP TABLE IF EXISTS league.division;
CREATE TABLE league.division (
    id int IDENTITY(1,1) PRIMARY KEY, 
    division_name nvarchar(100), 
    conference_id int NOT NULL,
    FOREIGN KEY (conference_id) REFERENCES league.conference(id)
)
GO

DROP TABLE IF EXISTS league.season;
CREATE TABLE league.season(
    league_starting_calendar_year int NOT NULL PRIMARY KEY
)
GO

DROP TABLE IF EXISTS league.week_type;
CREATE TABLE league.week_type (
    week_id int NOT NULL PRIMARY KEY,
    week_description nvarchar(100)
)
GO

DROP TABLE IF EXISTS league.season_week;
CREATE TABLE league.season_week (
    id int IDENTITY(1,1) PRIMARY KEY,
    league_season int NOT NULL, 
    league_week_type int NOT NULL, 
    FOREIGN KEY (league_season) REFERENCES league.season (league_starting_calendar_year),
    FOREIGN KEY (league_week_type) REFERENCES league.week_type (week_id)
)
GO

DROP TABLE IF EXISTS player.position_types;
CREATE TABLE player.position_types (
    id int IDENTITY(1,1) PRIMARY KEY,
    position_type nvarchar(20)
)
GO

DROP TABLE IF EXISTS player.football_positions;
CREATE TABLE player.football_positions (
    id int IDENTITY(1,1) PRIMARY KEY,
    position_name nvarchar(30) NOT NULL,
    position_abbreviation nvarchar(3) NOT NULL,
    position_type_id int NOT NULL,
	FOREIGN KEY (position_type_id) REFERENCES player.position_types (id)
)
GO

DROP TABLE IF EXISTS player.player;
CREATE TABLE player.player (
    id int IDENTITY(1,1) PRIMARY KEY,
    person_id int NOT NULL,
    active bit NOT NULL DEFAULT 1,
	FOREIGN KEY (person_id) REFERENCES league.person (id)
)
GO

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
)
GO



DROP TABLE IF EXISTS team.staff_roles;
CREATE TABLE team.staff_roles (
    id int IDENTITY(1,1) PRIMARY KEY,
    role_title nvarchar(50) NOT NULL,
    coach bit NOT NULL
)
GO

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
)
GO

DROP TABLE IF EXISTS team.season_finish_type;
CREATE TABLE team.season_finish_type(
    id int IDENTITY(1,1) PRIMARY KEY,
    finish_type nvarchar(50) NOT NULL
)
GO

DROP TABLE IF EXISTS team.season;
CREATE TABLE team.season (
    id int IDENTITY(1,1),
    team_id int NOT NULL,
    league_season int NOT NULL,
    win_total int NOT NULL,
    loss_total int NOT NULL,
    tie_total int NOT NULL,
    season_finish_type_id int NOT NULL,
    FOREIGN KEY (season_finish_type_id) REFERENCES team.season_finish_type(id)
)
GO

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
GO
 
DROP TABLE IF EXISTS team.roster;
CREATE TABLE team.roster ( 
    id int IDENTITY(1,1) PRIMARY KEY,
    team_id int NOT NULL,
    player_id int NOT NULL,
    jersey_number int NOT NULL,
	FOREIGN KEY (player_id) REFERENCES player.player (id)
);
GO

DROP TABLE IF EXISTS team.roster_positions;
CREATE TABLE team.roster_positions (
    id int IDENTITY(1,1) PRIMARY KEY,
    roster_id int NOT NULL,
    football_position_id int NOT NULL,
    FOREIGN KEY (roster_id) REFERENCES team.roster (id),
    FOREIGN KEY (football_position_id) REFERENCES player.football_positions (id)

)
GO

DROP TABLE IF EXISTS team.stadium_ownership_type;
CREATE TABLE team.stadium_ownership_type(
    id int IDENTITY(1,1) PRIMARY KEY,
    ownership_type nvarchar(200)
)
GO

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
)
GO

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
GO

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
)
GO

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

DROP TABLE IF EXISTS player.transaction_type;
CREATE TABLE player.transaction_type (
    id int IDENTITY(1,1) PRIMARY KEY,
    type_of_transaction nvarchar(50) NOT NULL
)
GO

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
GO

DROP TABLE IF EXISTS league.game;
CREATE TABLE league.game (
    id int IDENTITY(1,1) PRIMARY KEY,
    league_season_week int NOT NULL,
    game_date datetime NOT NULL,
    home_team_id int NOT NULL,
    away_team_id int NOT NULL,
    game_stadium int NOT NULL,
    played bit NOT NULL DEFAULT 0,
    home_team_final_score int NULL,
    away_team_final_score int NULL,
    FOREIGN KEY (league_season_week) REFERENCES league.season_week (id),
    FOREIGN KEY (home_team_id) REFERENCES team.nfl_team (id),
    FOREIGN KEY (away_team_id) REFERENCES team.nfl_team (id),
    FOREIGN KEY (game_stadium) REFERENCES league.stadium (id)
);

DROP TABLE IF EXISTS stats.player_game_passer_box_score;
CREATE TABLE stats.player_game_passer_box_score (
    id int IDENTITY(1,1) PRIMARY KEY,
    game_id int NOT NULL, --FK to nfl.game
    team_player_id int NOT NULL, --FK to team.players
    game_started bit NOT NULL,
    num_snaps int NOT NULL DEFAULT 0,
    -- Pass
    pass_attempts int NOT NULL DEFAULT 0,
    completions int NOT NULL DEFAULT 0,
    passing_yards int NOT NULL DEFAULT 0,
    passing_tds int NOT NULL DEFAULT 0,
    interceptions_thrown int NOT NULL DEFAULT 0,
    sacks_taken int NOT NULL DEFAULT 0,
    sack_yards_lost int NOT NULL DEFAULT 0, -- Constraint should be 0 when sacks taken is 0
    -- Rush as Passer
    passer_rush_attempts int NOT NULL DEFAULT 0,
    passer_rush_yards int NOT NULL DEFAULT 0,
    passer_rush_tds int NOT NULL DEFAULT 0,
    --Fumbles
    fumbles int NOT NULL DEFAULT 0,
    fumbles_lost int NOT NULL DEFAULT 0,
    fumbles_recovered int NOT NULL DEFAULT 0,
    fumbles_recovered_yards int NOT NULL DEFAULT 0,
    --Overall
    passer_rating decimal NOT NULL DEFAULT 0,
    fourth_quarter_comeback bit NOT NULL DEFAULT 0,
    game_winning_drive bit NOT NULL DEFAULT 0,
    FOREIGN KEY (game_id) REFERENCES league.game (id),
    FOREIGN KEY (team_player_id) REFERENCES team.roster (id)
)
GO

DROP TABLE IF EXISTS stats.player_game_rec_rush_box_score;
CREATE TABLE stats.player_game_rec_rush_box_score (
    id int IDENTITY(1,1) PRIMARY KEY,
    game_id int NOT NULL, --FK to nfl.game
    team_player_id int NOT NULL, --FK to team.players
    num_snaps int NOT NULL DEFAULT 0,
    --Receiving
    receiving_targets int NOT NULL DEFAULT 0,
    receptions int NOT NULL DEFAULT 0,
    receiving_yards int NOT NULL DEFAULT 0,
    receiving_tds int NOT NULL DEFAULT 0,
    first_downs_receiving int NOT NULL DEFAULT 0,
    longest_reception_length int NOT NULL DEFAULT 0,
    yards_before_catch int NOT NULL DEFAULT 0,
    yards_after_catch int NOT NULL DEFAULT 0,
    interceptions_when_targeted int NOT NULL DEFAULT 0,
    dropped_passes int NOT NULL DEFAULT 0,
    broken_tackles_receiving int NOT NULL DEFAULT 0,
    passer_rating_when_targeted int NOT NULL DEFAULT 0,
    --Rushing
    rush_attempts int NOT NULL DEFAULT 0,
    rushing_yards int NOT NULL DEFAULT 0,
    rushing_tds int NOT NULL DEFAULT 0,
    first_downs_rushing int NOT NULL DEFAULT 0,
    longest_rush_length int NOT NULL DEFAULT 0,
    broken_tackles_rushing int NOT NULL DEFAULT 0,
    yards_before_contact int NOT NULL DEFAULT 0,
    yards_after_contact int NOT NULL DEFAULT 0,
    --Fumbles
    fumbles int NOT NULL DEFAULT 0,
    fumbles_lost int NOT NULL DEFAULT 0,
    fumbles_recovered int NOT NULL DEFAULT 0,
    fumbles_recovered_yards int NOT NULL DEFAULT 0,
    FOREIGN KEY (game_id) REFERENCES league.game (id),
    FOREIGN KEY (team_player_id) REFERENCES team.roster (id)
)
GO

DROP TABLE IF EXISTS stats.player_game_defensive_box_score;
CREATE TABLE stats.player_game_defensive_box_score (
    id int IDENTITY(1,1) PRIMARY KEY,
    game_id int NOT NULL, --FK to nfl.game
    team_player_id int NOT NULL, --FK to team.players
    num_snaps int NOT NULL DEFAULT 0,
    --Pass Coverage
    targets_as_defender int NOT NULL DEFAULT 0,
    completions_against int NOT NULL DEFAULT 0,
    receiving_yards_allowed int NOT NULL DEFAULT 0,
    receiving_tds_allowed int NOT NULL DEFAULT 0,
    passer_rating_when_def_assignment_targeted decimal NOT NULL DEFAULT 0.0,
    air_yards_allowed_on_completions int NOT NULL DEFAULT 0,
    yards_after_catch_allowed_on_completions int NOT NULL DEFAULT 0,
    interceptions int NOT NULL DEFAULT 0,
    interception_return_yards int NOT NULL DEFAULT 0,
    interception_tds int NOT NULL DEFAULT 0,
    --Pass Rush
    blitzes int NOT NULL DEFAULT 0,
    hurries int NOT NULL DEFAULT 0,
    qb_knockdowns int NOT NULL DEFAULT 0,
    qb_pressures int NOT NULL DEFAULT 0,
    sacks int NOT NULL DEFAULT 0,
    --Tackles
    solo_tackles int NOT NULL DEFAULT 0,
    assisted_tackles int NOT NULL DEFAULT 0,
    tackles_for_loss int NOT NULL DEFAULT 0,
    qb_hits int NOT NULL DEFAULT 0,
    missed_tackles int NOT NULL DEFAULT 0,
    safeties int NOT NULL DEFAULT 0,
    FOREIGN KEY (game_id) REFERENCES league.game (id),
    FOREIGN KEY (team_player_id) REFERENCES team.roster (id)
)
GO

DROP TABLE IF EXISTS stats.player_game_kick_box_score;
CREATE TABLE stats.player_game_kick_box_score (
    id int IDENTITY(1,1) PRIMARY KEY,
    game_id int NOT NULL, --FK to nfl.game
    team_player_id int NOT NULL, --FK to team.players
    num_snaps int NOT NULL DEFAULT 0,
    --Kicking
    fg_attempts_10_19 int NOT NULL DEFAULT 0,
    fg_makes_10_19 int NOT NULL DEFAULT 0,
    fg_attempts_20_29 int NOT NULL DEFAULT 0,
    fg_makes_20_29 int NOT NULL DEFAULT 0,
    fg_attempts_30_39 int NOT NULL DEFAULT 0,
    fg_makes_30_39 int NOT NULL DEFAULT 0,
    fg_attempts_40_49 int NOT NULL DEFAULT 0,
    fg_makes_40_49 int NOT NULL DEFAULT 0,
    fg_attempts_over_50 int NOT NULL DEFAULT 0,
    fg_makes_over_50 int NOT NULL DEFAULT 0,
    long_field_goal int NOT NULL DEFAULT 0,
    extra_points_attempted int NOT NULL DEFAULT 0,
    extra_points_made int NOT NULL DEFAULT 0,
    --Kick Offs
    kick_offs int NOT NULL DEFAULT 0,
    kick_off_yards_returned int NOT NULL DEFAULT 0,
    touchbacks int NOT NULL DEFAULT 0,
    onside_attempts int NOT NULL DEFAULT 0,
    onside_successes int NOT NULL DEFAULT 0,
    --Punting
    punts int NOT NULL DEFAULT 0,
    punt_yards_gained int NOT NULL DEFAULT 0,
    long_punt int NOT NULL DEFAULT 0,
    punts_blocked int NOT NULL DEFAULT 0,
    FOREIGN KEY (game_id) REFERENCES league.game (id),
    FOREIGN KEY (team_player_id) REFERENCES team.roster (id)
)
GO

DROP TABLE IF EXISTS stats.player_game_return_box_score;
CREATE TABLE stats.player_game_return_box_score (
    id int IDENTITY(1,1) PRIMARY KEY,
    game_id int NOT NULL, --FK to nfl.game
    team_player_id int NOT NULL, --FK to team.players
    --Punt returns
    punts_returned int NOT NULL DEFAULT 0,
    punt_return_yards int NOT NULL DEFAULT 0,
    punt_return_tds int NOT NULL DEFAULT 0,
    long_punt_return int NOT NULL DEFAULT 0,
    --kick returns 
    kicks_returned int NOT NULL DEFAULT 0,
    kick_return_yards int NOT NULL DEFAULT 0,
    kick_return_tds int NOT NULL DEFAULT 0,
    long_kick_return int NOT NULL DEFAULT 0,
    FOREIGN KEY (game_id) REFERENCES league.game (id),
    FOREIGN KEY (team_player_id) REFERENCES team.roster (id)
)
GO

CREATE OR ALTER PROCEDURE league.create_draft_assets
	@league_year int
AS
BEGIN
	DECLARE @preexisting_count int, @fresh_count int;;
	CREATE TABLE #draft_stage (team_id int, round_num int)
	
	DECLARE @i int = 0, @rounds int = 7
	WHILE(@i < @rounds)
	BEGIN
		SET @i = @i + 1
		INSERT INTO #draft_stage (team_id, round_num)
		SELECT id, @i
		FROM team.nfl_team
	END

	SET @preexisting_count = (SELECT COUNT(1) FROM team.draft_asset WHERE league_season = @league_year)
	SET @fresh_count = (SELECT COUNT(1) FROM #draft_stage)
	IF (@fresh_count < @preexisting_count)
	BEGIN
		PRINT(@league_year + ' has pre-existing compensatory picks. Please manually deelte before reloading.' )
		RAISERROR('Draft Assets already exist with additional compensatory picks added. Please delete old assets before generating new ones ', 18, 1)

	END ELSE BEGIN
		DELETE FROM team.draft_asset WHERE league_season = @league_year;
		DECLARE @used bit = 0;
		-- Check if draft has already taken place
		IF @league_year  < YEAR(GETDATE()) OR (YEAR(GETDATE()) = @league_year AND DATENAME(dayofyear , GetDate()) > DATENAME(dayofyear, DATEFROMPARTS(@league_year, 4, 28)))
		BEGIN
			SET @used = 1
		END
		INSERT INTO team.draft_asset ([owner_team_id], [original_team_id], [league_season], [pick_round], [compensatory], [used])
		SELECT team_id, team_id, @league_year, round_num, 0, @used FROM #draft_stage
	END
END


