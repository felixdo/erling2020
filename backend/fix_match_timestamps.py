import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from python_settings import settings
from datetime import datetime

from conf import settings as my_local_settings
settings.configure(my_local_settings)


cred = credentials.Certificate(settings.FIREBASE_CONFIG['serviceAccount'])
firebase_admin.initialize_app(cred)
db = firestore.client()
batch = db.batch()

i=0    
query=db.collection('matches').select(['utcDate'])
for match in query.stream():
    val = match.get('utcDate')
    if (isinstance(val, str)): #if it's still a str, we havent converted it yet and must fix it
        theDate=datetime.strptime(val, "%Y-%m-%dT%H:%M:%SZ")
        match.reference.update({ 'utcDate' : theDate })
        i+=1
        if (i == 499):
            batch.commit()

batch.commit()




