CREATE SCHEMA stats;
DROP TABLE IF EXISTS stats.game;
CREATE TABLE stats.game (
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

-- Will only have record if player took snap on that side of ball.
DROP TABLE IF EXISTS stats.player_game_passer_box_score;
CREATE TABLE stats.player_game_passer_box_score (
    id int IDENTITY(1,1) PRIMARY KEY,
    game_id int NOT NULL,
    team_player_id int NOT NULL,
    game_started bit NOT NULL,
    num_snaps int NOT NULL DEFAULT 0,
    -- Pass
    pass_attempts int NOT NULL DEFAULT 0,
    completions int NOT NULL DEFAULT 0,
    passing_yards int NOT NULL DEFAULT 0,
    passing_tds int NOT NULL DEFAULT 0,
    interceptions_thrown int NOT NULL DEFAULT 0,
    sacks_taken int NOT NULL DEFAULT 0,
    sack_yards_lost int NOT NULL DEFAULT 0,
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
    FOREIGN KEY (game_id) REFERENCES stats.game (id),
    FOREIGN KEY (team_player_id) REFERENCES team.roster (id)
);

-- Will only have record if player took snap on that side of ball. QB w/o defensive snaps won't have record
DROP TABLE IF EXISTS stats.player_game_rec_rush_box_score;
CREATE TABLE stats.player_game_rec_rush_box_score (
    id int IDENTITY(1,1) PRIMARY KEY,
    game_id int NOT NULL,
    team_player_id int NOT NULL,
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
    FOREIGN KEY (game_id) REFERENCES stats.game (id),
    FOREIGN KEY (team_player_id) REFERENCES team.roster (id)
);

DROP TABLE IF EXISTS stats.player_game_defensive_box_score;
CREATE TABLE stats.player_game_defensive_box_score (
    id int IDENTITY(1,1) PRIMARY KEY,
    game_id int NOT NULL,
    team_player_id int NOT NULL,
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
    FOREIGN KEY (game_id) REFERENCES stats.game (id),
    FOREIGN KEY (team_player_id) REFERENCES team.roster (id)
);

DROP TABLE IF EXISTS stats.player_game_kick_box_score;
CREATE TABLE stats.player_game_kick_box_score (
    id int IDENTITY(1,1) PRIMARY KEY,
    game_id int NOT NULL,
    team_player_id int NOT NULL,
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
    FOREIGN KEY (game_id) REFERENCES stats.game (id),
    FOREIGN KEY (team_player_id) REFERENCES team.roster (id)
);

DROP TABLE IF EXISTS stats.player_game_return_box_score;
CREATE TABLE stats.player_game_return_box_score (
    id int IDENTITY(1,1) PRIMARY KEY,
    game_id int NOT NULL,
    team_player_id int NOT NULL,
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
    FOREIGN KEY (game_id) REFERENCES stats.game (id),
    FOREIGN KEY (team_player_id) REFERENCES team.roster (id)
);
