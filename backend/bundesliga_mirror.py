import pyrebase
import json
from football_data import get_football_data
from python_settings import settings
from cloud_firestore import set_matches
import os

from conf import settings as my_local_settings
settings.configure(my_local_settings)

season=settings.FOOTBALLDATA_CONFIG['BL1_SEASON']

bundesliga1_matches = '/v2/competitions/BL1/matches?season=%s' % season

def prepare_bl_matches(response):
    """ removes unwanted data from football-data json """
    matches = response['matches']
    result = {}
    for m in matches:
        matchId = m.pop('id')
        m.pop('odds', None)
        m.pop('referees', None)
        stage = m.pop('stage', None)
        m.pop('season', None)
        m.pop('group', None)
        if (m['status'] == 'SCHEDULED'):
            m.pop('score', None)
        elif (stage == 'REGULAR_SEASON'):
            m['score'].pop('duration', None)
            m['score'].pop('extraTime', None)
            m['score'].pop('penalties', None)
        result[str(matchId)] = m
    return result


response=get_football_data(bundesliga1_matches)

if (response):
    matchlist=prepare_bl_matches(response)
    #print (json.dumps(matchlist, indent=4, sort_keys=False))
    result = set_matches("BL1", season, matchlist)

