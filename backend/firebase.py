import pyrebase
from python_settings import settings

def test():
    print (settings.FIREBASE_CONFIG)


def set_matches(competition, year, matchlist):
    firebase = pyrebase.initialize_app(settings.FIREBASE_CONFIG)
    db = firebase.database()
    firebase_result = (db.child('football-data')
        .child('competitions')
        .child(competition)
        .child(year)
        .child('matches')
        .set(matchlist)
    )
    return firebase_result

