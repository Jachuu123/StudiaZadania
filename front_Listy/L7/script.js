class TodoApp {
  constructor() {
    this.todos = [];
    this.todoListUL = document.getElementById("todo-list");
    this.countElement = document.getElementById("count");
    this.form = document.getElementById("add-todo-form");
    this.clearAllButton = document.getElementById("todos-clear");

    this.init();
  }

  init() {
    this.loadTodos();
    this.form.addEventListener("submit", (e) => this.addTodo(e));
    this.clearAllButton.addEventListener("click", () => this.clearTodos());
    this.render();
  }

  loadTodos() {
    Array.from(this.todoListUL.children).forEach((li) => {
      const text = li.querySelector(".todo-name").textContent.trim();
      const completed = li.classList.contains("todo__container--completed");
      this.todos.push({ text, completed });
    });
  }

  render() {
    this.todoListUL.innerHTML = "";
    this.todos.forEach((todo, index) => this.createTodoElement(todo, index));
    this.updateCount();
  }

  createTodoElement(todo, index) {
    const li = document.createElement("li");
    li.className = "todo__container" + (todo.completed ? " todo__container--completed" : "");
    li.dataset.index = index;

    const nameDiv = document.createElement("div");
    nameDiv.className = "todo-element todo-name";
    nameDiv.textContent = todo.text;
    li.appendChild(nameDiv);

    li.appendChild(this.createButton("↑", "move-up", () => this.moveUp(index)));
    li.appendChild(this.createButton("↓", "move-down", () => this.moveDown(index)));
    li.appendChild(this.createButton(todo.completed ? "Revert" : "Done", "", () => this.toggleCompletion(index)));
    li.appendChild(this.createButton("Remove", "", () => this.removeItem(index)));

    this.todoListUL.appendChild(li);
  }

  createButton(text, className, onClick) {
    const button = document.createElement("button");
    button.className = `todo-element todo-button ${className}`;
    button.textContent = text;
    button.addEventListener("click", onClick);
    return button;
  }

  updateCount() {
    const remaining = this.todos.filter((todo) => !todo.completed).length;
    this.countElement.textContent = remaining;
  }

  addTodo(event) {
    event.preventDefault();
    const input = this.form.querySelector("input[name='todo-name']");
    const text = input.value.trim();
    if (text) {
      this.todos.push({ text, completed: false });
      input.value = "";
      this.render();
    }
  }

  removeItem(index) {
    this.todos.splice(index, 1);
    this.render();
  }

  toggleCompletion(index) {
    this.todos[index].completed = !this.todos[index].completed;
    this.render();
  }

  moveUp(index) {
    if (index > 0) {
      [this.todos[index - 1], this.todos[index]] = [this.todos[index], this.todos[index - 1]];
      this.render();
    }
  }

  moveDown(index) {
    if (index < this.todos.length - 1) {
      [this.todos[index], this.todos[index + 1]] = [this.todos[index + 1], this.todos[index]];
      this.render();
    }
  }

  clearTodos() {
    this.todos = [];
    this.render();
  }
}

document.addEventListener("DOMContentLoaded", () => new TodoApp());
