USE [nfl]
GO

/****** Object:  Table [nfl].[person]    Script Date: 10/15/2021 2:34:13 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[nfl].[person]') AND type in (N'U'))
DROP TABLE [nfl].[person]
GO

/****** Object:  Table [nfl].[person]    Script Date: 10/15/2021 2:34:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [nfl].[person](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[first_name] [nvarchar](100) NOT NULL,
	[last_name] [nvarchar](100) NOT NULL
) ON [PRIMARY]
GO


