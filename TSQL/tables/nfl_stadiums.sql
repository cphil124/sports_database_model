CREATE TABLE nfl.stadium_ownership_type(
    id int IDENTITY(1,1),
    ownership_type nvarchar(200)
) 
INSERT INTO nfl.stadium_ownership_type(ownership_type) VALUES ('Owner of Team', 'Home City', 'Private Investors', 'Other')

CREATE TABLE nfl.stadium (
    id int IDENTITY(1,1) PRIMARY KEY,
    stadium_name nvarchar(100) NOT NULL,
    city_name nvarchar(100) NOT NULL,
    state_code_id int NOT NULL,
    stadium_ownership_type_id int NOT NULL,
    year_opened int NOT NULL,
    year_closed int NOT NULL DEFAULT 9999
    FOREIGN KEY (stadium_ownership_type_id) REFERENCES nfl.stadium_ownership_type (id)
)
INSERT INTO nfl.stadium (stadium_name, city_name, stadium_ownership_id) VALUES ('Gillette Stadium', 'Foxborough', 1)

CREATE TABLE nfl.team_stadium (
    id int IDENTITY(1,1),
    stadium_id int NOT NULL,
    team_id int NOT NULL,
    active bit NOT NULL DEFAULT 1
)