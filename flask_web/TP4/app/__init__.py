from flask import Flask
from config import Config
app = Flask(__name__)
# the config attribute of the flask object loads the
# configuration values from the Config module
app.config.from_object(Config)
from flask_login import LoginManager

login_manager = LoginManager(app)
login_manager.login_view = "login" #view fct pour le login
login_manager.login_message_category = "info" #category du message flash
login_manager.login_message = "You can not access this page. Please log in to access this page."

from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy( app )

from app import routes

