import { newMessage, setUsername, handleGameMessage, updatePlayers } from './Store';

let base = '192.168.29.251:8080';
let socketBase = 'ws://' + base;
let httpBase = 'http://' + base;

let connection;
let uuid;
let chatConnection;

function getURL(endpoint) {
    return `${ httpBase }${ endpoint }`;
}

// returns array of players
export async function getPlayers() {
    fetch(`${ httpBase }/players`)
            .then(res => res.json())
            .then(players => updatePlayers(players));
}

export async function connect(message) {
    
    // Get username from player
    let username = prompt(message ?? "Choose a username");

    // Create a web socket connection with username
    connection = new WebSocket(`${ socketBase }/connect?username=${ username }`);

    connection.onclose = function (event) {
        if (event.code == 4000) {
            // username was invalid
            connect('Username is invalid, please choose another');
        } else {
            connect();
        }
    };

    connection.onmessage = function (event) {
        try {
            const payload = JSON.parse(event.data);
            handleGameMessage(payload);
        } catch(e) {
            if (event.data.length == 36){
                uuid = event.data;
                setUsername(username);
                getPlayers();
            }
        }
    };
}

export async function connectToChat() {
    chatConnection = new WebSocket(`${ socketBase }/globalchat`);

    chatConnection.onmessage = (message) => newMessage(message.data);

    // Reopen connection if closed
    chatConnection.onclose = (event) => connectToChat();
}

export async function sendChat(message) {
    if (uuid) {
        return fetch(getURL(`/chat/${uuid}`), {
            method: 'POST',
            headers: {
                'Content-Type': 'application/text'
            },
            body: message
        });
    }
}

export async function updateUsername(username) {
    return fetch(getURL(`/username/${ uuid }`), {
        method: 'PUT',
        headers: { 'Content-Type': 'application/text' },
        body: username
    });
}

export async function requestGame(username) {
    return fetch(getURL(`/requestGame?to=${ username }&from=${ uuid }`), { method: 'POST' });
}

export async function respondToInvite(response, senderUsername) {
    return fetch(getURL(`/inviteResponse?response=${ response }&sender=${ senderUsername }&id=${ uuid }`), {
        method: 'POST'
    });
}

export async function submitShips(positions) {
    return fetch(getURL(`/game/ships`), {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            id: uuid,
            positions: positions
        })
    });
}

export async function attack(cell) {
    return fetch(getURL(`/game/attack/${uuid}/${cell}`), { method: 'POST'});
}

export async function gameChat(message) {
    return fetch(getURL(`/game/chat/${uuid}`), {
        method: 'POST',
        headers: { 'Content-Type': 'application/text' },
        body: message
    });
}

export async function surrender() {
    return fetch(getURL(`/game/surrender/${uuid}`), { method: 'POST' });
}