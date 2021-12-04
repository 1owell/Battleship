import { Board } from './Board';

class Game {
    constructor() {
        this.playerBoard   = new Board(true);
        this.opponentBoard = new Board(false);
    }

    attack(index) {
        console.log(index);
    }
}