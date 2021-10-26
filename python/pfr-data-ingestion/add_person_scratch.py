from io import TextIOWrapper
from sqlalchemy import Column, Integer, Date, Unicode, UnicodeText, String, Boolean, create_engine
from sqlalchemy.engine import Engine
from sqlalchemy.orm import Session
from sqlalchemy.ext.declarative import declarative_base
from typing import List, Dict
import csv

Base = declarative_base()

class DraftAsset(Base):
    __tablename__ = 'draft_asset'
    __table_args__ = {"schema": "team"}
    id = Column('id', Integer, nullable=False, primary_key=True)
    owner_team_id = Column('owner_team_id', Integer, nullable=False)
    original_team_id = Column('original_team_id', Integer, nullable=False) 
    league_season = Column('league_season', Integer, nullable=False) 
    pick_round = Column('pick_round', Integer, nullable=False)
    pick_player_id = Column('pick_player_id', Integer, nullable=False)
    pick_position = Column('pick_position', Integer, nullable=False)
    compensatory = Column('compensatory', Boolean, nullable=False)
    used = Column('used', Boolean, nullable=False)

class Person(Base):
    __tablename__ = 'person'
    __table_args__ = {"schema": "league"}
    id = Column('id', Integer, nullable=False, primary_key=True)
    first_name = Column('first_name', String, nullable=False)
    last_name = Column('last_name', String, nullable=False)
    date_of_birth = Column('date_of_birth', Date, nullable=True)
    alma_mater = Column('alma_mater', String, nullable=True)

class Player(Base):
    __tablename__ = 'player'
    __table_args__ = {"schema": "player"}
    id = Column('id', Integer, nullable=False, primary_key=True)
    person_id = Column('person_id', Integer, nullable = False)
    active = Column('active', Boolean, nullable = False)
    
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
            self.player_first_name, self.player_last_name = ' '.split(self.player_name)
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


class Team(Base):
    __tablename__ = 'nfl_team'
    __table_args__ = {"schema": "team"}
    id = Column('id', Integer, nullable=False, primary_key=True)
    team_name = Column('team_name', String, nullable=False)
    team_abbreviation = Column('team_abbreviation', String, nullable=False)
    team_region = Column('team_region', String, nullable=False)
    team_hq_state_id = Column('team_hq_state_id', Integer, nullable=False)
    team_division_id = Column('team_division_id', Integer, nullable=False)
    
engine = create_engine('mssql+pyodbc://sa:Password1@localhost/nfl?driver=SQL+Server', echo=True)
print(type(engine))
session = Session(engine)
# team_list = session.query(Team).all()

# team_code_dict = {}
# for team in team_list:
#     team_code_dict[team.team_abbreviation] = team.id
    
# print(team_code_dict.keys())

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

file_url = r'C:\Users\Cameron\Documents\Projects\Github\sports_database_model\scratch\2020_draft_asset.csv'

pick_list = read_csv_to_obj(file_url, DraftPick)

persons = session.query(Person).all()
# person_id_dict = {(person.first_name, person.last_name) : person.id for person in persons}
# print(person_id_dict)

def exec_procedure(session, proc_name, params:Dict[str:str], output:bool=False):
    """ Only handles single value integer return types for now. Will expand once a need arises"""
    sql_params = ",".join(["@{0}='{1}'".format(name, str(value)) for name, value in params.items()])
    # return_values_string = ''.join([f'DECLARE @return_value{x} int;\n' for x in range()])
    sql_string = """
        DECLARE @return_value int;
        EXEC {proc_name} {params}""".format(proc_name=proc_name, params=sql_params)
    if output:
        sql_string += """, @id=@return_value OUTPUT;
                            SELECT 'Return Value' = @return_value;"""

    return session.execute(sql_string).fetchall()

    

def add_person(person:Person, session:Session) -> int:
    proc_name = 'league.add_person'
    params = {
                'first_name' : person.first_name.replace("'", "''"), 
                'last_name' : person.last_name.replace("'", "''"),
                'date_of_birth' : person.date_of_birth,
                'alma_mater' : person.alma_mater.replace("'", "''")
            }
    result = exec_procedure(session, proc_name, params, True)
    return result[0][0]


def add_person(player:Player, session:Session) -> int:
    proc_name = 'league.add_person'
    params = {
                'first_name' : person.first_name.replace("'", "''"), 
                'last_name' : person.last_name.replace("'", "''"),
                'date_of_birth' : person.date_of_birth,
                'alma_mater' : person.alma_mater.replace("'", "''")
            }
    result = exec_procedure(session, proc_name, params, True)
    return result[0][0]


def draft_player():
    # Take Pick
    # Add Person
    # Take Person, add player
    # Add Player to Roster 
    # Update Draft Asset
    pass

player_list = []
for person in persons:
    player_list.append(
        Player(
            person_id = add_person(person, session),
            active = True
        )
    )
for player in player_list:
    print(player.__dict__)

# # players = [Player(person_id = person.id, active = True) for person in persons]
# # session.add_all(players)


session.rollback()