"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
// 1. Endpointy jako enum
var Endpoints;
(function (Endpoints) {
    Endpoints["ELIXIRS"] = "Elixirs";
    Endpoints["SPELLS"] = "Spells";
})(Endpoints || (Endpoints = {}));
// 3. Zmienna przechowująca poprawną odpowiedź
let validOption;
// 4. Kontener gry (wiemy, że istnieje – Non-null Assertion)
const gameContainer = document.getElementById("game");
// 5. Funkcja pobierająca dane
function fetchData(endpoint) {
    return __awaiter(this, void 0, void 0, function* () {
        const response = yield fetch(`https://wizard-world-api.herokuapp.com/${endpoint}`);
        if (!response.ok) {
            throw new Error(`Error fetching data from ${endpoint}`);
        }
        return response.json();
    });
}
// 6. Tablice na dane
let elixirs = [];
let spells = [];
// 7. Pobranie wszystkich danych
function fetchAllData() {
    return __awaiter(this, void 0, void 0, function* () {
        const [elixirsResponse, spellsResponse] = yield Promise.all([
            fetchData(Endpoints.ELIXIRS),
            fetchData(Endpoints.SPELLS),
        ]);
        // TS wie, że elixirsResponse to Elixir[]
        elixirs = elixirsResponse.filter(elixir => !!elixir.effect);
        spells = spellsResponse.filter(spell => !!spell.incantation);
    });
}
// 8. Generyczna funkcja losująca unikalne elementy
function getRandomElements(array, count) {
    const indexes = new Set();
    while (indexes.size < count) {
        indexes.add(Math.floor(Math.random() * array.length));
    }
    return Array.from(indexes).map(i => array[i]);
}
// 9. Generowanie opcji (dwie mylne + jedna poprawna)
function generateOptions(items) {
    const [rightOption, ...rest] = items;
    const options = [rightOption, ...rest].sort(() => Math.random() - 0.5);
    return { rightOption, options };
}
// 10. Runda dla eliksirów
function elixirGame() {
    const sample = getRandomElements(elixirs, 3);
    const { rightOption, options } = generateOptions(sample);
    validOption = rightOption.name;
    renderOptions(`Which elixir effect is: "${rightOption.effect}"?`, options.map(e => e.name));
}
// 11. Runda dla zaklęć
function spellGame() {
    const sample = getRandomElements(spells, 3);
    const { rightOption, options } = generateOptions(sample);
    validOption = rightOption.name;
    renderOptions(`Which spell incantation is: "${rightOption.incantation}"?`, options.map(s => s.name));
}
// 12. Rysowanie przycisków
function renderOptions(question, answers) {
    const questionElement = document.getElementById("question");
    gameContainer.innerHTML = "";
    questionElement.textContent = question;
    answers.forEach(answer => {
        const btn = document.createElement("button");
        btn.textContent = answer;
        gameContainer.appendChild(btn);
    });
}
// 13. Obsługa kliknięcia – poprawka typu
gameContainer.addEventListener("click", (event) => {
    // event.target to EventTarget, nie HTMLButtonElement
    const target = event.target;
    if (target.tagName === "BUTTON") {
        if (target.textContent === validOption) {
            round();
        }
        else {
            alert("Wrong answer!");
        }
    }
});
// 14. Nowa runda (losowo eliksir lub zaklęcie)
function round() {
    (Math.random() > 0.5 ? elixirGame : spellGame)();
}
// 15. Start gry
(function startGame() {
    return __awaiter(this, void 0, void 0, function* () {
        yield fetchAllData();
        round();
    });
})();
//# sourceMappingURL=game.js.map