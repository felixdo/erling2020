import pyrebase
import json
from football_data import get_football_data
from python_settings import settings
from firebase import set_matches
import os

from conf import settings as my_local_settings
settings.configure(my_local_settings)

season=settings.FOOTBALLDATA_CONFIG['BL1_SEASON']

bundesliga1_matches = '/v2/competitions/BL1/matches?season=%s' % season

def prepare_bl_matches(response):
    """ removes unwanted data from football-data json """
    matches = response['matches']
    result={}
    seasonData = None;
    for m in matches:
        m.pop('odds', None)
        m.pop('referees', None)
        m.pop('stage', None)
        seasonData = m.pop('season', None)
        m.pop('group', None)
        if (m['status'] == 'SCHEDULED'):
            m.pop('score', None)
        else:
            m['score'].pop('duration', None)
            m['score'].pop('extraTime', None)
            m['score'].pop('penalties', None)
        status = m.pop('status', "unknown")
        if (status not in result):
            result[status] = {}
        matchdays=result[status]
        matchday = m.pop('matchday', 'unknown')
        if (matchday not in matchdays):
            matchdays[matchday] = []
        matchdays[matchday].append(m)
    return result


response=get_football_data(bundesliga1_matches)
    

if (response):
    matchlist=prepare_bl_matches(response)
    result = set_matches("BL1", season, matchlist)

#print (json.dumps(matchlist, indent=4, sort_keys=False))
