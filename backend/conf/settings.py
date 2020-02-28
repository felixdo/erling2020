import os
from dotenv import load_dotenv

load_dotenv()

FIREBASE_CONFIG = {
  "apiKey": os.getenv("FIREBASE_APIKEY"),
  "authDomain": os.getenv("FIREBASE_AUTHDOMAIN"),
  "databaseURL": os.getenv("FIREBASE_DATABASEURL"),
  "storageBucket": os.getenv("FIREBASE_STORAGEBUCKET"),
  "serviceAccount": os.getenv("FIREBASE_SERVICEACCOUNT")
}

FOOTBALLDATA_CONFIG = {
  "token": os.getenv("FOOTBALL_DATA_TOKEN"),
  "BL1_SEASON": 2019
}



