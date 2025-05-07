// 1. Endpointy jako enum
enum Endpoints {
    ELIXIRS = "Elixirs",
    SPELLS  = "Spells",
  }
  
  // 2. Typy danych z API
  interface Elixir {
    id: string;
    name: string;
    effect: string;
    // ...inne pola wg dokumentacji, np. difficulty_level?: string;
  }
  
  interface Spell {
    id: string;
    name: string;
    incantation: string;
    // ...inne pola, np. type?: string;
  }
  
  // 3. Zmienna przechowująca poprawną odpowiedź
  let validOption: string;
  
  // 4. Kontener gry (wiemy, że istnieje – Non-null Assertion)
  const gameContainer = document.getElementById("game")!;
  
  // 5. Funkcja pobierająca dane
  async function fetchData<T>(endpoint: Endpoints): Promise<T[]> {
    const response = await fetch(
      `https://wizard-world-api.herokuapp.com/${endpoint}`
    );
    if (!response.ok) {
      throw new Error(`Error fetching data from ${endpoint}`);
    }
    return response.json() as Promise<T[]>;
  }
  
  // 6. Tablice na dane
  let elixirs: Elixir[] = [];
  let spells:   Spell[]   = [];
  
  // 7. Pobranie wszystkich danych
  async function fetchAllData() {
    const [elixirsResponse, spellsResponse] = await Promise.all([
      fetchData<Elixir>(Endpoints.ELIXIRS),
      fetchData<Spell>(Endpoints.SPELLS),
    ]);
  
    // TS wie, że elixirsResponse to Elixir[]
    elixirs = elixirsResponse.filter(elixir => !!elixir.effect);
    spells   = spellsResponse.filter(spell => !!spell.incantation);
  }
  
  // 8. Generyczna funkcja losująca unikalne elementy
  function getRandomElements<T>(array: T[], count: number): T[] {
    const indexes = new Set<number>();
    while (indexes.size < count) {
      indexes.add(Math.floor(Math.random() * array.length));
    }
    return Array.from(indexes).map(i => array[i]);
  }
  
  // 9. Generowanie opcji (dwie mylne + jedna poprawna)
  function generateOptions<T extends { name: string }>(
    items: T[]
  ): { rightOption: T; options: T[] } {
    const [rightOption, ...rest] = items;
    const options = [rightOption, ...rest].sort(() => Math.random() - 0.5);
    return { rightOption, options };
  }
  
  // 10. Runda dla eliksirów
  function elixirGame() {
    const sample = getRandomElements(elixirs, 3);
    const { rightOption, options } = generateOptions(sample);
    validOption = rightOption.name;
    renderOptions(
      `Which elixir effect is: "${rightOption.effect}"?`,
      options.map(e => e.name)
    );
  }
  
  // 11. Runda dla zaklęć
  function spellGame() {
    const sample = getRandomElements(spells, 3);
    const { rightOption, options } = generateOptions(sample);
    validOption = rightOption.name;
    renderOptions(
      `Which spell incantation is: "${rightOption.incantation}"?`,
      options.map(s => s.name)
    );
  }
  
  // 12. Rysowanie przycisków
  function renderOptions(question: string, answers: string[]) {
    const questionElement = document.getElementById("question")!;
    gameContainer.innerHTML = "";
    questionElement.textContent = question;
  
    answers.forEach(answer => {
      const btn = document.createElement("button");
      btn.textContent = answer;
      gameContainer.appendChild(btn);
    });
  }
  
  // 13. Obsługa kliknięcia – poprawka typu
  gameContainer.addEventListener("click", (event: MouseEvent) => {
    // event.target to EventTarget, nie HTMLButtonElement
    const target = event.target as HTMLButtonElement;
    if (target.tagName === "BUTTON") {
      if (target.textContent === validOption) {
        round();
      } else {
        alert("Wrong answer!");
      }
    }
  });
  
  // 14. Nowa runda (losowo eliksir lub zaklęcie)
  function round() {
    (Math.random() > 0.5 ? elixirGame : spellGame)();
  }
  
  // 15. Start gry
  (async function startGame() {
    await fetchAllData();
    round();
  })();
  