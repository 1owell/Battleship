import { writable } from 'svelte/store';
import { Ship } from './Models/Ship';

const cellWidth = 50;

export function stoppedDragging(ship, left, top) {
    // update board state with new ship position
    playerBoard.update(currentBoardState => {
        currentBoardState.ships[0].origin = {
            x: Math.max(Math.min(Math.round(left / cellWidth) + 1, 10), 1),
            y: Math.max(Math.min(Math.round(top / cellWidth) + 1, 10), 1) 
        }

        return currentBoardState;
    })

    // Set the ship origin to the nearest cell location
    
    // Check if ship is out of bounds
    if ((ship.origin.y >= (12 - ship.size) && ship.isVertical) || (ship.origin.x >= (12 - ship.size) && !ship.isVertical)) {
        ship.isValid = false;
    } else {
        ship.isValid = true;
    }
}


function createGame() {
    return new Game();
}

export const game = createGame();