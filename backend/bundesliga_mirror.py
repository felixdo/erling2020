import pyrebase
import json
from football_data import get_football_data
from python_settings import settings
from cloud_firestore import set_matches
import os
from datetime import datetime

from conf import settings as my_local_settings
settings.configure(my_local_settings)

season=settings.FOOTBALLDATA_CONFIG['BL1_SEASON']

competitions=['BL1', 'CL', 'EC']


def prepare_matches(response, competition):
    """ removes unwanted data from football-data json """
    matches = response['matches']
    result = {}
    for m in matches:
        m['utcDate'] = datetime.strptime(m['utcDate'], "%Y-%m-%dT%H:%M:%SZ")
        matchId = m.pop('id')
        season = m.pop('season')
        m['season_id'] = season['id']
        m['competition'] = competition
        m.pop('odds', None)
        m.pop('referees')
        if m['status'] == 'SCHEDULED':
            m.pop('score', None)
        else:
            score=m['score']
            if score is not None and score['duration'] == 'REGULAR':
                score.pop('extraTime', None)
                score.pop('penalties', None)

        result[str(matchId)] = m
    return result

matchlist = {}


for c in competitions:
    response=get_football_data('/v2/competitions/%s/matches' % c)
    if (response):
        matchlist.update(prepare_matches(response, c))

result = set_matches(matchlist)


