import { Ship } from './Ship';
import { writable } from 'svelte/store';

export class Board {
    static baseState(forPlayer) {
        if (forPlayer) {
            return {
                attacksReceived: [],
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
                attacksReceived: [],
                cells: [...Array(100).keys()].map(_ => 0)
            }
        }
    }


    constructor(isPlayer) {
        this.state = writable(Board.baseState(isPlayer));
    }


    stoppedDragging(updatedShip, left, top) {
        // update board state with new ship position
        const cellWidth = 50;
        this.state.update(currentBoardState => {
            const ship = currentBoardState.ships?.find(eachship => eachship.name === updatedShip.name);

            console.log(ship.origin);

            ship.origin = {
                x: Math.max(Math.min(Math.round(left / cellWidth) + 1, 10), 1),
                y: Math.max(Math.min(Math.round(top / cellWidth) + 1, 10), 1) 
            }
            
            ship.isVertical = updatedShip.isVertical;

            console.log(ship.origin);

            // Check if ship is out of bounds
            if ((ship.origin.y >= (12 - ship.size) && ship.isVertical) || (ship.origin.x >= (12 - ship.size) && !ship.isVertical)) {
                ship.isValid = false;
            } else {
                ship.isValid = true;
            }
    
            return currentBoardState;
        });        
    }
}