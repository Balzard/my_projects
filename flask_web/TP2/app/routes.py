from app import app
from flask import render_template, redirect
from flask import url_for, request, flash

#dic that contains the elements of the to do list and their values
tasks = {}
currentID = 1

app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'

#redirect to the page to add an element
@app.route("/add_element")
def add_element():
    return render_template("submit.html",action='pushtodo')


#load the todo list as home page
@app.route("/")
def hello_world_form():
    return render_template('todo.html',tasks=tasks)

#when we click on submit to add an element to the to do list
@app.route("/add",methods=['POST'])
def add():
    global currentID
    _element = request.form['task']

    #check we don't add an empty element
    if(_element!=''):
        #add the element to the dic
        tasks[_element+str(currentID)] = {'nom': _element,'etat':True,'id':str(currentID)}
        currentID+=1

    else:
        return render_template("submit.html")
    return render_template('todo.html',tasks = tasks)

#when we delete an element of the to do list
@app.route("/remove/<task>/<id>",methods=['GET'])
def remove(task,id):
    global currentID
    del tasks[task+id]
    currentID-=1
    return render_template('todo.html',tasks = tasks)

#to change the state of an element of the to do list (open or close)
@app.route("/state/<task>/<id>",methods=['POST'])
def change_state(task,id):
    if tasks[task+id]['etat']:
        tasks[task+id]['etat'] = False
    else:
        tasks[task+id]['etat']= True

    return render_template('todo.html',tasks=tasks)

#redirect to edit an element of the to do list
@app.route('/edit/<task>/<id>',methods=['POST'])
def edit_task(task,id):
    return render_template('update.html',action='change/'+task+'/'+id)

#change the value of the element and redirect to the to do list
@app.route('/change/<task>/<id>',methods=['POST'])
def update_task(task,id):
    element = request.form['task']
    if element != "":
        precedentID = tasks[task + id]["id"]
        tasks[element + precedentID] = {"nom": element, "etat": tasks[task + precedentID]["etat"],"id": precedentID}
        del tasks[task + id]
    return render_template('todo.html', tasks=tasks)


