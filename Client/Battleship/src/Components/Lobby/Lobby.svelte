<script>
    import GlobalChat from "./GlobalChat.svelte";
    import PlayerMenu from "./PlayerMenu.svelte";
    import Players from "./Players.svelte";
    import { player } from "../../Store";

    let selectedPlayer;
</script>

<div class="container">
    <div class="header">
        <h1>Battleship Arena</h1>
        <h3>{ $player.username ?? 'No Username' }</h3>
    </div>
    
    <div class="players">
        <Players bind:selectedPlayer={ selectedPlayer } />    
    </div>

    <div class="menu">
        <PlayerMenu player={ selectedPlayer } />
    </div>

    <div class="chat">
        <GlobalChat />
    </div>
    
</div>

<style>
    .container {
        display: grid;
        grid-template-areas: 
            "header  header  chat"
            "players players chat"
            "menu    menu    chat";
        grid-template-rows: 1fr 4fr 1fr;
        gap: 20px 20px;
        height: 100%;
        margin: 40px;
        color: white;
    }

    .header {
        grid-area: header;
    }

    .players {
        grid-area: players;
    }

    .menu {
        grid-area: menu;
    }

    .chat {
        grid-area: chat;
    }
</style>