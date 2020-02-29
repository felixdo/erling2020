import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from python_settings import settings

def set_matches(competition, year, matchlist):
    # Use a service account
    cred = credentials.Certificate(settings.FIREBASE_CONFIG['serviceAccount'])
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    batch = db.batch()
    #collectionref = db.collection('competitions', competition, 'seasons', year, 'matches')

    for (matchId, match) in matchlist.items():
        docref=db.document('competitions', competition, 'seasons', year, 'matches', matchId)
        batch.create(docref, match)
    batch.commit()



