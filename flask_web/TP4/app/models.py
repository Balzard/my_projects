from flask_login import UserMixin
from app.forms import MyRegistrationForm
from app import db, login_manager
from werkzeug.security import generate_password_hash,check_password_hash
from datetime import datetime
# class user hérite de usermixin et db.Model pour pouvoir interagir avec la bd
#slide 32, on a pas ajouté les méthodes car on les hérite de usermixin
class User(UserMixin, db.Model):

    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(16))
    firstName = db.Column(db.String(120), nullable=False)
    lastName = db.Column(db.String(40),nullable=False)
    birth = db.Column(db.String(10),nullable=False)
    password_hash = db.Column(db.String(128))
    admin = db.Column(db.Boolean,default=False)
    blocked = db.Column(db.Boolean, default=False)

    def getUsername(self):
        return self.username

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)


class Todo(db.Model):
    __tablename__ = "todo"
    id = db.Column(db.Integer,primary_key=True,autoincrement=True)
    name = db.Column(db.String(80), unique=False,nullable=False)
    description = db.Column(db.String(256),nullable=True)
    date = db.Column(db.String(10),nullable=False)
    status = db.Column(db.Boolean,nullable=False)
    user_id = db.Column(db.Integer,db.ForeignKey('users.id'))


db.drop_all()
db.create_all()

# callback to reload the user object
@login_manager.user_loader
def load_user(userid):
    return User.query.get(int(userid))



