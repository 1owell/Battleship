import { Board } from './Board';

export class Game {
    constructor() {
        this.playerBoard   = new Board(true);
        this.opponentBoard = new Board(false);
    }
}