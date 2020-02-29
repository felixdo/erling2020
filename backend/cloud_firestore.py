import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from python_settings import settings

def set_matches(matchlist):
    # Use a service account
    cred = credentials.Certificate(settings.FIREBASE_CONFIG['serviceAccount'])
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    batch = db.batch()

    i = 0
    for (matchId, match) in matchlist.items():
        docref=db.document('matches', matchId)
        batch.set(docref, match, merge=True)
        i+=1
        if (i == 499):
            batch.commit()
            i = 0
        
    batch.commit()



