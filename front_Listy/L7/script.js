document.addEventListener("DOMContentLoaded", () => {
    let todos = [];
  
    const todoListUL = document.getElementById("todo-list");
  
    Array.from(todoListUL.children).forEach(li => {
      const text = li.querySelector(".todo-name").textContent.trim();
      const completed = li.classList.contains("todo__container--completed");
      todos.push({ text, completed });
    });
  
    function render() {
      todoListUL.innerHTML = "";
  
      todos.forEach((todo, index) => {
        const li = document.createElement("li");
        li.className = "todo__container" + (todo.completed ? " todo__container--completed" : "");
        li.dataset.index = index;
  
        const nameDiv = document.createElement("div");
        nameDiv.className = "todo-element todo-name";
        nameDiv.textContent = todo.text;
        li.appendChild(nameDiv);
  

        const upBtn = document.createElement("button");
        upBtn.className = "todo-element todo-button move-up";
        upBtn.textContent = "↑";
        li.appendChild(upBtn);
  

        const downBtn = document.createElement("button");
        downBtn.className = "todo-element todo-button move-down";
        downBtn.textContent = "↓";
        li.appendChild(downBtn);
  
        const toggleBtn = document.createElement("button");
        toggleBtn.className = "todo-element todo-button";
        toggleBtn.textContent = todo.completed ? "Revert" : "Done";
        li.appendChild(toggleBtn);

        const removeBtn = document.createElement("button");
        removeBtn.className = "todo-element todo-button";
        removeBtn.textContent = "Remove";
        li.appendChild(removeBtn);

        todoListUL.appendChild(li);
      });

      const countElement = document.getElementById("count");
      const remaining = todos.filter(todo => !todo.completed).length;
      countElement.textContent = remaining;
    }
  
    const form = document.getElementById("add-todo-form");
    form.addEventListener("submit", function(event) {
      event.preventDefault();
      const input = form.querySelector("input[name='todo-name']");
      const text = input.value.trim();
      if (text !== "") {
        todos.push({ text, completed: false });
        input.value = "";
        render();
      }
    });
  
    todoListUL.addEventListener("click", function(event) {
      const target = event.target;
      if (target.tagName.toLowerCase() !== "button") return;
      
      const li = target.closest("li");
      if (!li) return;
      
      const index = parseInt(li.dataset.index, 10);
      const action = target.textContent.trim();
      
      if (action === "Remove") {
        todos.splice(index, 1);
        render();
      } else if (action === "Done") {
        todos[index].completed = true;
        render();
      } else if (action === "Revert") {
        todos[index].completed = false;
        render();
      } else if (action === "↑") {
        if (index > 0) {
          [todos[index - 1], todos[index]] = [todos[index], todos[index - 1]];
          render();
        }
      } else if (action === "↓") {
        if (index < todos.length - 1) {
          [todos[index], todos[index + 1]] = [todos[index + 1], todos[index]];
          render();
        }
      }
    });
  
    const clearAll = document.getElementById("todos-clear");
    clearAll.addEventListener("click", function() {
      todos = [];
      render();
    });
  
    render();
  });
  