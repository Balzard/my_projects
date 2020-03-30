from flask import Flask
from config import Config
app = Flask(__name__)
# the config attribute of the flask object loads the
# configuration values from the Config module
app.config.from_object(Config)
from app import routes