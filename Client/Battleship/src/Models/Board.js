import { Cell } from './Cell';

class Board {
    static baseState(forPlayer) {
        if (forPlayer) {
            return {
                attacksReceived: [],
                cells: [...Array(100).keys()].map(idx => new Cell(idx)),
                ships: [
                    new Ship('Carrier', 5, 1),
                    new Ship('Battleship', 4, 2),
                    new Ship('Cruiser', 3, 3),
                    new Ship('Submarine', 3, 4),
                    new Ship('Destroyer', 2, 5)
                ]
            }
        } else {
            return {
                attacksReceived: [],
                cells: [...Array(100).keys()].map(idx => new Cell(idx))
            }
        }
    }


    constructor(isPlayer) {
        this.state = writable(Board.baseState(isPlayer));
    }
}