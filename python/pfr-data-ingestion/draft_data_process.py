from io import TextIOWrapper
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, Date, Unicode, UnicodeText, String, Boolean
from typing import List
import csv
# from sqlalchemy.sql.sqltypes import Boolean
# "Provided by ""https://www.sports-reference.com/sharing.html?utm_source=direct&utm_medium=Share&utm_campaign=ShareTool"">Pro-Football-Reference.com</a>: <a href=""https://www.pro-football-reference.com/years/2020/draft.htm?sr&utm_source=direct&utm_medium=Share&utm_campaign=ShareTool#drafts"">View Original Table</a><br>Generated 10/24/2021."

Base = declarative_base()

class DraftAsset(Base):
    __tablename__ = 'team.draft_asset'
    id = Column('id', Integer, nullable=False, primary_key=True)
    owner_team_id = Column('owner_team_id', Integer, nullable=False)
    original_team_id = Column('original_team_id', Integer, nullable=False)
    league_season = Column('league_season', Integer, nullable=False)
    pick_round = Column('pick_round', Integer, nullable=False)
    pick_player_id = Column('pick_player_id', Integer, nullable=False)
    pick_position = Column('pick_position', Integer, nullable=False)
    compensatory = Column('compensatory', Boolean, nullable=False)
    used = Column('used', Boolean, nullable=False)

class Team(Base):
    __tablename__ = 'team.nfl_team'
    id = Column('id', Integer, nullable=False, primary_key=True)
    team_name = Column('team_name', String, nullable=False)
    team_abbreviation = Column('team_abbreviation', String, nullable=False)
    team_region = Column('team_region', String, nullable=False)
    team_hq_state_id = Column('team_hq_state_id', Integer, nullable=False)
    team_division_id = Column('team_division_id', Integer, nullable=False)

class DraftPick():
    def __init__(self, round:int, pick:int, team:str, name: str, position_abbrev:str, age:int, alma_mater:str):
        self.round = round
        self.pick_number = pick
        self.team = team
        self.player_name = name
        self.position_abbrev = position_abbrev
        self.age = age
        self.alma_mater = alma_mater
        try:
            self.player_first_name, self.player_last_name = self.player_name.split(' ')
        except ValueError:
            self.player_first_name = self.player_name
            self.player_last_name = 'N/A'
            
    def fix_pfr_name(self):
        self.player_name = self.player_name.split('\\')[0]
        try:
            self.player_first_name, self.player_last_name = self.player_name.split(' ')
        except ValueError:
            self.player_first_name = self.player_name
            self.player_last_name = 'N/A'

def read_csv_to_obj(file_name:str, obj:object, header:bool = True) -> List[object]:
    with open(file_name, 'r') as file_stream:
        obj_list = []
        csvreader = csv.reader(file_stream)
        if header:
            head = next(csvreader)
        try:
            for line in csvreader:
                if not line:
                    break
                instance = obj(*line)
                obj_list.append(instance)
        except TypeError as e:
            print(e)
    return obj_list

def main():


if __name__ == '__main__':
    main()

