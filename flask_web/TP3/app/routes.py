from app import app
from flask import render_template, redirect, url_for, flash, request
from app.forms import MyLoginForm
from app.forms import MyRegistrationForm, AddTaskForm
from app.models import User
from werkzeug.urls import url_parse
from flask_login import login_required, login_user, logout_user, current_user, LoginManager

from flask_login import login_required, login_user,logout_user, current_user
from app.models import User
# create some users with ids 1 to 5
users = {'simon': {'username':'simon','password':'hahaha','firstname':'simon','lastname':'polet','birthdate':'10/06/1998','admin': True, 'blocked':False,
                   'todo' :{}}}
tasks = {}
currentID = 1


@app.route('/register',methods=['GET','POST'])
def register():
    form = MyRegistrationForm()
    if form.validate_on_submit():
        for user in users.values():
            #check the username doesn't exist
            if form.username == user['username']:
                flash('This user already exists','danger')
                redirect(url_for('register'))
            #check both password are the same
            if form.password.data != form.confirm_password.data:
                flash('Passwords have to be the same','danger')
                redirect(url_for('register'))

        #add user to users
        users[form.username.data] = {'username':form.username.data,
                                     'password':form.password.data,
                                     'firstname':form.firstName.data,
                                     'lastname':form.lastName.data,
                                     'birthdate':form.birthDate.data,
                                     'admin': False,
                                     'blocked':False,
                                     'todo': {}}

        return redirect(url_for('login'))

    return render_template('my_registration_form.html', form=form)


@app.route('/login',methods=['GET','POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('/'))
    form = MyLoginForm()
    if form.validate_on_submit():
        user_found = False
        for n in users.values():
            if(n['username'] == form.username.data):
                pwd = n["password"]
                block = n['blocked']
                user_found = True

        if user_found:
            #flash if user is blocked
             if(block == True):
                flash('You are blocked','danger')
                return redirect(url_for('login'))

            #check is password corresponds and login
             if (pwd == form.password.data ):

                user = User(form.username.data)
                login_user(user)

                return redirect(url_for('main'))
             else:
                flash('Wrong password', 'danger')
                return redirect(url_for('login'))
        else:
            flash('Wrong username', 'danger')
            return redirect(url_for('login'))
    else:
        return render_template('my_login_form.html', form=form)

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404

# Log out user
@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('main'))

#to acceed to submit page
@app.route("/add_element")
@login_required
def add_element():
    form = AddTaskForm()
    name = form.taskName.data
    description = form.description.data
    date = form.date.data
    return render_template("submit.html",action='pushtodo',form=form,admin=users[current_user.getID()]['admin'])


#load the todo list as home page
@app.route("/")
@login_required
def main():
    return render_template('todo.html',tasks=users[current_user.getID()]['todo'], admin=users[current_user.getID()]['admin'])

#render the users registered with their infos
@app.route("/users")
@login_required
def users_list():
    return render_template("admin.html", users=users, admin=users[current_user.getID()]['admin'])

#to change the status of the user in the admin page (admin or not)
@app.route('/admin/<user>')
@login_required
def admin(user):
    currentUser = users[current_user.getID()]
    users[user]['admin'] = not users[user]['admin']
    return render_template('admin.html', users=users, admin=currentUser['admin'])

#to block or deblock a user in the admin page
@app.route('/block/<user>')
@login_required
def block(user):
    currentUser = users[current_user.getID()]
    users[user]['blocked'] = not users[user]['blocked']
    return render_template('admin.html', users=users, admin=currentUser['admin'])

#when we click on submit to add an element to the todo key of the current user
@app.route("/add",methods=['POST'])
@login_required
def add():
    global currentID
    form = AddTaskForm()
    name = form.taskName.data
    description = form.description.data
    date = form.date.data

    #add the element to the dic
    users[current_user.getID()]['todo'][name + str(currentID)] = {'name':name,'description':description,'date':date,'state':True,'id':str(currentID)}
    currentID+=1

    return render_template('todo.html',tasks = users[current_user.getID()]['todo'], admin=users[current_user.getID()]['admin'])

#when we delete an element of the to do list
@app.route("/remove/<task>/<id>",methods=['GET'])
@login_required
def remove(task,id):
    global currentID
    del users[current_user.getID()]['todo'][task+id]
    currentID-=1
    return render_template('todo.html',tasks = users[current_user.getID()]['todo'],
                           admin=users[current_user.getID()]['admin'])

#to change the state of an element of the to do list of the current user (open or close)
@app.route("/state/<task>/<id>",methods=['POST'])
@login_required
def change_state(task,id):
    current_task = users[current_user.getID()]['todo']

    users[current_user.getID()]['todo'][task + id]['state'] = \
        not (users[current_user.getID()]['todo'][task + id]['state'])

    return render_template('todo.html',tasks=users[current_user.getID()]['todo'],
                           admin=users[current_user.getID()]['admin'])

#redirect to edit an element of the to do list of the current user
@app.route('/edit/<task>/<id>',methods=['POST'])
@login_required
def edit_task(task,id):
    form = AddTaskForm()
    name = form.taskName.data
    description = form.description.data
    date = form.date.data
    user = users[current_user.getID()]
    return render_template('update.html',action='change/'+task+'/'+id, tasks = user['todo'][task+id],admin = user['admin'],form=form)

#change the value of the element and redirect to the to do list
@app.route('/change/<task>/<id>',methods=['POST'])
@login_required
def update_task(task,id):
    form = AddTaskForm()
    name = form.taskName.data
    description = form.description.data
    date = form.date.data
   
    precedentID = users[current_user.getID()]['todo'][task+id]['id']

    users[current_user.getID()]['todo'][name + id] = \
    users[current_user.getID()]['todo'][task + id]

    users[current_user.getID()]['todo'][name+id]['name'] = name
    
    #delete old value of the task
    del users[current_user.getID()]['todo'][task + id]

    users[current_user.getID()]['todo'][name + id]['description'] = description
    users[current_user.getID()]['todo'][name + id]['date'] = date

    return render_template('todo.html', tasks=users[current_user.getID()]['todo'],admin=users[current_user.getID()]['admin'],form=form)