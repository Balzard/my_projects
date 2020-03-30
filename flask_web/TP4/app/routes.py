from asyncio import tasks

from app import app, db
from flask import render_template, redirect, url_for, flash, request
from app.forms import MyLoginForm, ShortMessageForm
from app.forms import MyRegistrationForm, AddTaskForm
from app.models import User, Todo
from werkzeug.urls import url_parse
from flask_login import login_required, login_user, logout_user, current_user, LoginManager

from flask_login import login_required, login_user,logout_user, current_user
from app.models import User

#create admin account
def create_admin():
    user = User(username = "admin",firstName = "stephane", lastName="leblanc", birth="10-06-1998",admin=True)
    user.set_password("admin")
    db.session.add(user)
    db.session.commit()

create_admin()

@app.route('/')
@login_required
def main():
    user = User.query.filter_by(username = current_user.getUsername()).first()
    tasks = Todo.query.filter_by(user_id=user.id).all()
    return render_template('todo.html',tasks = tasks, admin=user.admin)

@app.route('/login', methods=['get', 'post'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('/'))

    form = MyLoginForm()
    if form.validate_on_submit():  # check if it is a POST request and if it is valid
        user = User.query.filter_by(username=form.username.data).first()
        if user is None:
            flash('You are not registered yet', 'danger')
            return redirect(url_for('login'))
        elif not user.check_password(form.password.data):
            flash('Invalid username or password', 'danger')
            return redirect(url_for('login'))
        if user.blocked == True:
            flash("Sorry you are blocked",'danger')
            return redirect(url_for('login'))
        login_user(user)
        next_page = request.args.get('next')
        if not next_page or url_parse(next_page).netloc != '':
            next_page = url_for('main')
        return redirect(next_page)
    else:
        return render_template('my_login_form.html', form=form)

@app.route('/register', methods=['GET', 'POST'])
def register():
     if current_user.is_authenticated:
        return redirect(url_for('main'))
     form = MyRegistrationForm()

     if form.validate_on_submit():
        user = User(username=form.username.data, firstName=form.firstname.data,lastName=form.lastname.data,birth=form.date.data,admin=False)
        user.set_password(form.password.data)
        db.session.add(user)
        db.session.commit()
        flash('Congratulations, you are now a registered user!', 'info')
        return redirect(url_for('login'))
     return render_template('my_registration_form.html', title='Register', form=form)

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('main'))


@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404


#to acceed to submit page
@app.route("/add_element")
@login_required
def add_element():
    form = AddTaskForm()
    user = User.query.filter_by(username = current_user.getUsername()).first()
    return render_template("submit.html",action='pushtodo',form=form,admin = user.admin)


#render the users registered with their infos
@app.route("/users")
@login_required
def users_list():
    user = User.query.filter_by(username = current_user.getUsername()).first()
    users = User.query.all()
    return render_template("admin.html", users=users, admin=user.admin)

#to change the status of the user in the admin page (admin or not)
@app.route('/admin/<user>')
@login_required
def admin(user):
    user = User.query.filter_by(username = user).first()
    user.admin = not user.admin
    db.session.commit()
    users = User.query.all()
    return render_template('admin.html', users=users, admin=current_user.admin)

#to block or deblock a user in the admin page
@app.route('/block/<user>')
@login_required
def block(user):
    currentUser = User.query.filter_by(username=user).first()
    currentUser.blocked = not currentUser.blocked
    db.session.commit()
    users = User.query.all()
    return render_template('admin.html', users=users, admin=current_user.admin)

#when we click on submit to add an element to the todo key of the current user
@app.route("/add",methods=['POST'])
@login_required
def add():
    user = User.query.filter_by(username = current_user.getUsername()).first()
    form = AddTaskForm()

    name = form.taskName.data
    description = form.description.data
    date = form.date.data
    task = Todo(user_id = user.id, name=name,description=description,date=date,status=True)
    db.session.add(task)
    db.session.commit()

    todo = Todo.query.filter_by(user_id = current_user.id).all()
    return render_template('todo.html',tasks=todo, admin=user.admin)


#when we delete an element of the to do list
@app.route("/remove/<task>/<id>",methods=['GET'])
@login_required
def remove(task,id):
    user = User.query.filter_by(username = current_user.getUsername()).first()
    task = Todo.query.filter_by(id=id).first()
    db.session.delete(task)
    db.session.commit()

    tasks = Todo.query.filter_by(user_id = user.id).all()
    return render_template('todo.html',tasks = tasks, admin = user.admin)

#to change the state of an element of the to do list of the current user (open or close)
@app.route("/state/<task>/<id>",methods=['POST'])
@login_required
def change_state(task,id):
    user = User.query.filter_by(username = current_user.getUsername()).first()
    task = Todo.query.filter_by(id=id).first()

    task.status = not task.status
    db.session.commit()
    tasks = Todo.query.filter_by(user_id = user.id).all()

    return render_template('todo.html',tasks=tasks, admin=user.admin)

#redirect to edit an element of the to do list of the current user
@app.route('/edit/<task>/<id>',methods=['POST'])
@login_required
def edit_task(task,id):
    user = User.query.filter_by(username = current_user.getUsername()).first()
    form = AddTaskForm()

    tasks = Todo.query.filter_by(id=id).first()

    return render_template('update.html',action='change/'+task+'/'+id, tasks = tasks,admin = user.admin,form=form)

#change the value of the element of the todo list and redirect to the to do list
@app.route('/change/<task>/<id>',methods=['POST'])
@login_required
def update_task(task,id):
    user = User.query.filter_by(username = current_user.getUsername()).first()
    task = Todo.query.filter_by(id=id).first()

    form = AddTaskForm()
    name = form.taskName.data
    description = form.description.data
    date = form.date.data

    task.name = name
    task.description = description
    task.date = date
    db.session.add(task)
    db.session.commit()

    tasks = Todo.query.filter_by(user_id = user.id).all()

    return render_template('todo.html', tasks=tasks,admin=user.admin,form=form)



