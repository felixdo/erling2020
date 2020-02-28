import http.client
import json
from python_settings import settings

def get_football_data(query):
    connection = http.client.HTTPConnection('api.football-data.org')
    headers = { 'X-Auth-Token': settings.FOOTBALLDATA_CONFIG['token'] }
    connection.request('GET', query, None, headers )
    response = connection.getresponse()
    if (response.status == 200):
        print ("OK api.football-data.org%s" % query)
        return json.loads(response.read().decode())
    else:
        raise Exception(response.reason + response.status)

