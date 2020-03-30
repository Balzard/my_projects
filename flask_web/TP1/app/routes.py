from app import app
from flask import render_template, redirect
from flask import url_for, request, flash

tasks = []
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'

@app.route("/")
def hello_world_form():
    return render_template('todo.html',tasks=tasks)

@app.route("/add",methods=['POST'])
def add():
    _element = request.form['task']

    if(_element==''):
        flash('please enter something')
        return render_template('todo.html',tasks=tasks)

    tasks.append(_element)
    return render_template('todo.html',tasks = tasks)

@app.route("/remove/<task>",methods=['GET'])
def remove(task):
    tasks.remove(task)
    return render_template('todo.html',tasks = tasks)




