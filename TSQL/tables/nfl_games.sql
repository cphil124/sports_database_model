CREATE TABLE nfl.game (
    id int IDENTITY(1,1),
    nfl_season int NOT NULL,
    nfl_week int NOT NULL,
    game_date datetime NOT NULL,
    home_team_id int NOT NULL,
    away_team_id int NOT NULL,
    game_stadium int NOT NULL,
    played bit NOT NULL DEFAULT 0,
    home_team_final_score int NULL,
    away_team_final_score int NULL
)

CREATE SCHEMA nfl_stats
-- Will only have record if player took snap on that side of ball.
CREATE TABLE nfl_stats.player_game_passer_box_score (
    id int IDENTITY(1,1),
    game_id int NOT NULL, --FK to nfl.game
    team_player_id int NOT NULL, --FK to nfl.team_players
    game_started bit NOT NULL,
    num_snaps int NOT NULL,
    -- Pass
    pass_attempts int NOT NULL,
    copmletions int NOT NULL,
    passing_yards int NOT NULL,
    passing_tds int NOT NULL,
    interceptions_thrown int NOT NULL,
    sacks_taken int NOT NULL,
    sack_yards_lost int NOT NULL, -- Constraint should be 0 when sacks taken is 0
    -- Rush as Passer
    passer_rush_attempts int NOT NULL,
    passer_rush_yards int NOT NULL,
    passer_rush_tds int NOT NULL,
    --Fumbles
    fumbles int NOT NULL,
    fumbles_lost int NOT NULL,
    fumbles_recovered int NOT NULL,
    fumbles_recovered_yards int NOT NULL,
    --Overall
    passer_rating decimal NOT NULL,
    fourth_quarter_comeback bit NOT NULL DEFAULT 0,
    game_winning_drive bit NOT NULL DEFAULT 0
)

-- Will only have record if player took snap on that side of ball. QB w/o defensive snaps won't have record
CREATE TABLE nfl_stats.player_game_rec_rush_box_score (
    id int IDENTITY(1,1),
    game_id int NOT NULL, --FK to nfl.game
    team_player_id int NOT NULL, --FK to nfl.team_players
    num_snaps int NOT NULL,
    --Receiving
    receiving_targets int NOT NULL,
    receptions int NOT NULL,
    receiving_yards int NOT NULL,
    receiving_tds int NOT NULL,
    first_downs_receiving int NOT NULL,
    longest_reception_length int NOT NULL,
    yards_before_catch int NOT NULL,
    yards_after_catch int NOT NULL,
    interceptions_when_targeted int NOT NULL,
    dropped_passes int NOT NULL,
    broken_tackles_receiving int NOT NULL,
    passer_rating_when_targeted int NOT NULL,
    --Rushing
    rush_attempts int NOT NULL,
    rushing_yards int NOT NULL,
    rushing_tds int NOT NULL,
    first_downs_rushing int NOT NULL,
    longest_rush_length int NOT NULL,
    broken_tackles_rushing int NOT NULL,
    yards_before_contact int NOT NULL,
    yards_after_contact int NOT NULL,
    --Fumbles
    fumbles int NOT NULL,
    fumbles_lost int NOT NULL,
    fumbles_recovered int NOT NULL,
    fumbles_recovered_yards int NOT NULL,
)

CREATE TABLE nfl_stats.player_game_defensive_box_score (
    id int IDENTITY(1,1),
    game_id int NOT NULL, --FK to nfl.game
    team_player_id int NOT NULL, --FK to nfl.team_players
    num_snaps int NOT NULL,
    --Pass Coverage
    targets_as_defender int NOT NULL,
    completions_against int NOT NULL,
    receiving_yards_allowed int NOT NULL,
    receiving_tds_allowed int NOT NULL,
    passer_rating_when_def_assignment_targeted decimal NOT NULL,
    air_yards_allowed_on_completions int NOT NULL,
    yards_after_catch_allowed_on_completions int NOT NULL,
    interceptions int NOT NULL,
    interception_return_yards int NOT NULL,
    interception_tds int NOT NULL,
    --Pass Rush
    blitzes int NOT NULL,
    hurries int NOT NULL,
    qb_knockdowns int NOT NULL,
    qb_pressures int NOT NULL,
    sacks int NOT NULL,
    --Tackles
    solo_tackles int NOT NULL,
    assisted_tackles int NOT NULL,
    tackles_for_loss int NOT NULL,
    qb_hits int NOT NULL,
    missed_tackles int NOT NULL,
    safeties int NOT NULL
)

CREATE TABLE nfl_stats.player_game_kick_box_score (
    id int IDENTITY(1,1),
    game_id int NOT NULL, --FK to nfl.game
    team_player_id int NOT NULL, --FK to nfl.team_players
    num_snaps int NOT NULL
    --Kicking
    fg_attempts_10_19 int NOT NULL,
    fg_makes_10_19 int NOT NULL,
    fg_attempts_20_29 int NOT NULL,
    fg_makes_20_29 int NOT NULL,
    fg_attempts_30_39 int NOT NULL,
    fg_makes_30_39 int NOT NULL,
    fg_attempts_40_49 int NOT NULL,
    fg_makes_40_49 int NOT NULL,
    fg_attempts_50+ int NOT NULL,
    fg_makes_50+ int NOT NULL,
    long_field_goal int NOT NULL,
    extra_points_attempted int NOT NULL,
    extra_points_made int NOT NULL,
    --Kick Offs
    kick_offs int NOT NULL,
    kick_off_yards_returned int NOT NULL,
    touchbacks int NOT NULL,
    onside_attempts int NOT NULL,
    onside_successes int NOT NULL,
    --Punting
    punts int NOT NULL,
    punt_yards_gained int NOT NULL,
    long_punt int NOT NULL,
    punts_blocked int NOT NULL
)

CREATE TABLE nfl_stats.player_game_return_box_score (
    id int IDENTITY(1,1),
    game_id int NOT NULL, --FK to nfl.game
    team_player_id int NOT NULL, --FK to nfl.team_players
    --Punt returns
    punts_returned int NOT NULL,
    punt_return_yards int NOT NULL,
    punt_return_tds int NOT NULL,
    long_punt_return int NOT NULL,
    --kick returns 
    kicks_returned int NOT NULL,
    kick_return_yards int NOT NULL,
    kick_return_tds int NOT NULL,
    long_kick_return int NOT NULL
)

-- Can be compiled as an aggregate of player game box scores
-- CREATE VIEW nfl.team_game_box_score AS 
-- SELECT 1
--     
--     
-- 