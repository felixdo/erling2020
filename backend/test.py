import firebase
from python_settings import settings
from conf import settings as my_local_settings
settings.configure(my_local_settings)

firebase.test()

