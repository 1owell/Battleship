<script>
    import Board from "./Board.svelte";
    import ChatBox from "./ChatBox.svelte";
    import { surrender } from "../../BattleShipAPI";
    import { player } from '../../Store';

    $: turn = $player.turnActive;
    $: game = $player.game;
</script>

<div class="game">
    <div class="player { turn ? 'turn' : '' }">
        <h3>{ $player.username || 'Your Board' }</h3>
        <Board board={game.playerBoard} />
        <ChatBox />
        <button on:click="{ () => surrender() }">Surrender</button>
    </div>

    <div class="player { turn ? '' : 'turn' }">
        <h3>{ $player.opponentName || 'Their Board'}</h3>
        <Board board={game.opponentBoard} />
        <p>{ $player.opponentMessage || "Silence..." }</p>
    </div>
</div>

<style>
    .game {
        display: flex;
    }

    .player {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 50%;
    }

    h3 {
        color: white;
    }

    .turn {
        border: 4px solid white;
    }
    
    button {
        background: none;
        color: white;
    }
</style>