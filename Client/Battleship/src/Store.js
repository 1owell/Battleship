import { writable, get } from 'svelte/store';
import { Game } from './Models/Game';

export const chatMessages = new writable([]);
export const players = new writable([]);
export const player = new writable({
    inGame: false,
    turnActive: false,
    opponentName: ''
});


export function setOpponent(opponent) {
    player.update(p => {
        p.opponentName = opponent;
        return p;
    });
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
    console.log(payload);
    switch (payload.status) {
        case 0:
            // game start
            startGame();
            break;
        case 1:
            // turn start
            turnStart(payload.board);
            break;
        case 2:
            // turn end
            turnEnd(payload.board);
            break;
        case 3:
            // lost
            endGame(false);
            break;
        case 4:
            // won
            endGame(true);
            break;
        case 5:
            // chat
            postGameChatMessage(payload.chat);
            break;
        case 6:
            // game request
            processGameRequest(payload.proposal.fromPlayer);
            break;
    }  
}

function startGame() {
    player.update(playerState => {
        playerState.inGame = true;
        playerState.game   = new Game();
        return playerState;
    });
}

function turnStart(boardStates) {
    player.update(playerState => {
        playerState.turnActive = true;
        playerState.game.playerBoard.update(boardStates.playerState);
        playerState.game.opponentBoard.update(boardStates.opponentState);
        return playerState;
    });
}

function turnEnd(boardStates) {
    player.update(playerState => {
        playerState.turnActive = false;
        playerState.game.playerBoard.update(boardStates.playerState);
        playerState.game.opponentBoard.update(boardStates.opponentState);
        return playerState;
    });
}

function endGame(didWin) {
    let opponent = ''
    player.update(playerState => {
        playerState.inGame     = false;
        playerState.turnActive = false;
        playerState.game       = undefined;
        playerState.opponentMessage = '';
        opponent = playerState.opponentName;
        return playerState;
    });

    if (didWin) {
        window.alert("You beat " + opponent);
    } else {
        window.alert("You lost to " + opponent);
    }
}

function postGameChatMessage(message) {
    player.update(p => {
        p.opponentMessage = message.message;
        return p;
    })
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