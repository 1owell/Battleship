import { Ship } from './Ship';
import { writable, get } from 'svelte/store';

export class Board {
    static baseState(forPlayer) {
        if (forPlayer) {
            return {
                cells: [...Array(100).keys()].map(_ => 0),
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
                cells: [...Array(100).keys()].map(_ => 0)
            }
        }
    }


    constructor(isPlayer) {
        this.state = writable(Board.baseState(isPlayer));
        this.submitted = false;
    }


    get shipPositions() {
        return get(this.state).ships.map(ship => ship.cells);
    }


    get hits() {
        return get(this.state).cells.filter(cell => cell == 2).length;
    }

    get misses() {
        return get(this.state).cells.filter(cell => cell == 1).length;
    }

    get attacks() {
        return get(this.state).cells.filter(cell => cell > 0).length;
    }

    get accuracyPercentage() {
        const attacks = this.attacks;
        if (attacks > 0) {
            return Math.floor((this.hits / this.attacks) * 100);
        }
        return 0;
    }

    isHit(cell) {
        return get(this.state).cells[cell - 1] > 0;
    }

    update(cells) {
        this.state.update(currentBoardState => {
            currentBoardState.cells = cells;
            return currentBoardState;
        });
    }

    stoppedDragging(updatedShip, left, top, didRotate) {
        // update board state with new ship position
        this.state.update(currentBoardState => {
            const ship = currentBoardState.ships?.find(eachship => eachship.name === updatedShip.name);
            const oldOrigin = ship.origin;
            const newOrigin = this.#origin(left, top);

            if (didRotate) {
                ship.toggleOrientation();
            }
            // Check that two ships aren't overlapping
            const currentShipPositions = currentBoardState.ships
                                                        .filter(ship => updatedShip.origin != ship.origin)
                                                        .flatMap(ship => ship.cells);

            ship.origin = newOrigin;
            
            // get other ship positions
            // compare new ship position to other ship positions
            const join = currentShipPositions.concat(ship.cells);

            if (new Set(join).size != join.length) {
                
                ship.origin = oldOrigin;
                if (didRotate) ship.toggleOrientation();
                return currentBoardState;
            }

            if ((ship.row >= (12 - ship.size) && ship.isVertical) || (ship.col >= (12 - ship.size) && !ship.isVertical)) {
                ship.origin = oldOrigin;
                if (didRotate) ship.toggleOrientation();
                return currentBoardState;
            }

            return currentBoardState;
        });        
    }

    #origin(left, top) {
        const cellWidth = 50;
        const x = Math.max(Math.min(Math.round(left / cellWidth) + 1, 10), 1);
        const y = Math.max(Math.min(Math.round(top / cellWidth) + 1, 10), 1);
        return (y - 1) * 10 + x;
    }
}