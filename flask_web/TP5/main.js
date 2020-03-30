var add_btn = document.getElementById("task_button");
var task_input = document.getElementById("task");
var list = document.getElementById("list");
var nb_task = document.getElementById("nb_tasks");
var nb_finished_tasks = document.getElementById("nb_tasks_finished");

//current number of tasks
var tasks = 0;
//current number of finished tasks
var finished=0;

// add ul element to the div
var ul = document.createElement("ul");
list.appendChild(ul);

class todo {
    constructor(name, status) {
        this.name = name;
        this.status = status;
    }
}

add_btn.addEventListener("click",function(){
    //value of input entered by user
    let valeur  = task_input.value;

    //instancie todo object with input value as name
    let task = new todo(valeur,false);

    let li = document.createElement("li");

    //alert if user try to add empty element
    if(valeur == ""){
        alert("you can't add empty element");
        return;
    }
    
    let node = document.createTextNode(task.name);
    ul.appendChild(li);
    li.appendChild(node);

    //to erase value of input after submit
    task_input.value="";

    //increment number of tasks
    tasks +=1;

    nb_task.innerHTML = "Number of task: " + tasks;
    nb_finished_tasks.innerHTML = "Number of finished tasks: " + finished;

    //click listener on each element of the list to increment or decrement number of finished tasks
    li.addEventListener("click",function(){
        if(task.status == false){
            li.style.textDecoration = "line-through"
            task.status = true;
            finished +=1;
            nb_finished_tasks.innerHTML = "Number of finished tasks: " + finished;}
        else{
            li.style.textDecoration = "none";
            task.status = false;
            finished -=1;
            nb_finished_tasks.innerHTML = "Number of finished tasks: " + finished;
        }
    })
})