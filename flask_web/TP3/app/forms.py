from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, DateField
from wtforms.validators import ValidationError, InputRequired, Length, Email, EqualTo

#herite de flaskform
class MyLoginForm( FlaskForm):

     username = StringField('Username:', validators=[InputRequired(), Length(min=5,max=20)])
     password = PasswordField('Password:', validators=[Length(min=3, max=16)])
     submit = SubmitField('Send')

class MyRegistrationForm(FlaskForm):
    firstName = StringField('Fisrt name:', validators=[InputRequired(), Length(min=3,max=20)])
    lastName = StringField('Last name:', validators=[InputRequired(), Length(min=3,max=20)])
    birthDate = StringField('Birth date:',validators=[InputRequired()])
    username = StringField('Username:', validators=[InputRequired(), Length(min=5, max=20)])
    password = PasswordField('Password:', validators=[InputRequired(),Length(min=5)])
    confirm_password = PasswordField('Confirm password', validators=[InputRequired(), Length(min=5)])
    submit = SubmitField('Send')

class AddTaskForm(FlaskForm):
    taskName = StringField('Task :', validators=[InputRequired()])
    description = StringField('Description :')
    date = StringField('Date :', validators=[InputRequired()])
    submit = SubmitField('Add')