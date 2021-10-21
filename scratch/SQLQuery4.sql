USE [nfl]
GO

ALTER TABLE [nfl].[team_draft_assets] DROP CONSTRAINT [DF__team_draf__compe__5DCAEF64]
GO

/****** Object:  Table [nfl].[team_draft_assets]    Script Date: 10/15/2021 2:43:02 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[nfl].[team_draft_assets]') AND type in (N'U'))
DROP TABLE [nfl].[team_draft_assets]
GO

/****** Object:  Table [nfl].[team_draft_assets]    Script Date: 10/15/2021 2:43:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS team.draft_asset;
CREATE TABLE team.draft_asset (
    id int IDENTITY(1,1) PRIMARY KEY,
    original_team int NOT NULL,
    league_season_id int NOT NULL,
    pick_round int NOT NULL,
    compensatory bit NOT NULL DEFAULT 0
    FOREIGN KEY (original_team) REFERENCES team.nfl_team (id),
    FOREIGN KEY (league_season_id) REFERENCES league.season (league_starting_calendar_year)
)

ALTER TABLE [nfl].[team_draft_assets] ADD  DEFAULT ((0)) FOR [compensatory]
GO


