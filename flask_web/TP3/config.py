import os, binascii

#récupérer les schémas
basedir = os.path.abspath(os.path.dirname(__file__))

class Config(object):
    # path of the folder where the file is to be uploaded to the server
    UPLOAD_FOLDER = "C:/Users/Stou/upload_web_cours_4"
    MAX_CONTENT_LENGTH = 0.1 * 1024 * 1024  # 16 Megabyte
    SECRET_KEY = binascii.hexlify(os.urandom(24))

    """SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir,'users.db')  # or 'sqlite:/// + global path to db
    SQLALCHEMY_TRACK_MODIFICATIONS = False"""
