from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, DateField
from wtforms.validators import ValidationError, InputRequired, Length, Email, EqualTo

#herite de flaskform


class MyLoginForm( FlaskForm ):
     username = StringField('Username:', validators=[InputRequired(), Length(min=5, max=80)])
     password = PasswordField('Password:', validators=[InputRequired(), Length(min=3, max=16)])
     submit = SubmitField('Login')

class MyRegistrationForm(FlaskForm):
      username = StringField('Username:', validators=[InputRequired(),Length(min=5, max=80)])
      firstname = StringField('First Name', validators=[InputRequired(), Length(min=3,max=20)])
      lastname = StringField('Last Name',validators=[InputRequired(),Length(min=3,max=30)])
      date = StringField('Birth Date', validators=[InputRequired()])
      password = PasswordField('Password:', validators=[InputRequired(),Length(min=3, max=16)])
      password2 = PasswordField('Repeat Password', validators=[InputRequired(),EqualTo('password')])
      submit = SubmitField('Register')
      def validate_username(self, username):
          user = User.query.filter_by(username=username.data).first()
          if user is not None:
                raise ValidationError('Please use a different username.')

class AddTaskForm(FlaskForm):
    taskName = StringField('Task :', validators=[InputRequired()])
    description = StringField('Description :')
    date = StringField('Date :', validators=[InputRequired()])
    submit = SubmitField('Add')


class ShortMessageForm( FlaskForm ):
     text = StringField('Leave your short message here:', validators=[InputRequired(), Length(min=0, max=200)])
     submit = SubmitField('Send')

from app.models import User