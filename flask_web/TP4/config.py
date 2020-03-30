import os, binascii

#récupérer les schémas
basedir = os.path.abspath(os.path.dirname(__file__))
class Config(object):
     SECRET_KEY = binascii.hexlify(os.urandom(24))
     SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir,'users.db') # or 'sqlite:/// + global path to db
     SQLALCHEMY_TRACK_MODIFICATIONS = False
