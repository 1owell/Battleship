import { writable, get } from 'svelte/store';
import { Game } from './Models/Game';
import { attack } from './BattleShipAPI';

export const chatMessages = new writable([]);
export const players = new writable([]);
export const player = new writable({
    inGame: false,
    turnActive: false,
    opponentName: ''
});


export function attemptAttack(index) {
    if (get(player).turnActive) {
        attack(index + 1);
    }
}

export function updatePlayers(playersArray) {
    players.update(_ => playersArray);
}

export function newMessage(message) {
    try {
        if (typeof message === 'string') {
            const messabeObj = JSON.parse(message).chat;
            chatMessages.update(messages => [messabeObj, ...messages]);
        } else if (typeof message === 'object') {
            chatMessages.update(messages => [message, ...messages]);
        }
        
    } catch {
        console.log("Failed to parse incoming chat message:", message);
    }
}

export function setUsername(newUsername) {
    player.update(user => {
        user.username = newUsername;
        return user;
    });
}

export function handleGameMessage(payload) {
    switch (payload.status) {
        case 0:
            // game start
            startGame();
        case 1:
            // turn start
            turnStart();
        case 2:
            // turn end
            turnEnd();
        case 3:
            // lost
            endGame(false);
        case 4:
            // won
            endGame(true);
        case 5:
            // chat
            postGameChatMessage(payload.chat);
        case 6:
            // game request
            processGameRequest(payload.proposal.fromPlayer);
    }
}

function startGame() {
    player.update(playerState => {
        playerState.inGame = true;
        playerState.game   = new Game();
        return playerState;
    });
}

function turnStart() {
    player.update(playerState => {
        playerState.turnActive = true;
        return playerState;
    });
}

function turnEnd() {
    player.update(playerState => {
        playerState.turnActive = false;
        return playerState;
    });
}

function endGame(didWin) {
    const opponent = ''
    player.update(playerState => {
        playerState.inGame = false;
        playerState.turnActive = false;
        playerState.game = undefined;
        opponent = playerState.opponentName;
        return playerState;
    });

    if (didWin) {
        alert("You beat" + opponent);
    } else {
        alert("You lost to " + opponent);
    }
}

function postGameChatMessage(message) {

}

function processGameRequest(sender) {
    let date = new Date().getTime()
    newMessage({
        date: date / 1000,
        id: date,
        username: sender,
        isInvite: true
    });
}