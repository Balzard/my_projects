from flask_login import UserMixin
from app.forms import MyRegistrationForm
from app import login_manager
from werkzeug.security import generate_password_hash,check_password_hash
from datetime import datetime
# class user hérite de usermixin et db.Model pour pouvoir interagir avec la bd
#slide 32, on a pas ajouté les méthodes car on les hérite de usermixin
class User(UserMixin):

     def __init__(self, id):
         self.id = id

     def getID(self):
         return self.id


#callback to reload the user object
@login_manager.user_loader
def load_user(user_id):
    return User(user_id)



