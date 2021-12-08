<script>
    import Board from "./Board.svelte";
    import ChatBox from "./ChatBox.svelte";
    import { player } from '../../Store';
    import { Game } from '../../Models/Game';

    //let game = new Game();

    $: turn = $player.turnActive;
    $: game = $player.game;
</script>

<div class="game">
    <div class="player { turn ? 'turn' : '' }">
        <h3>{ $player.username || 'Your Board' }</h3>
        <Board board={game.playerBoard} />
        <ChatBox />
    </div>

    <div class="player { turn ? '' : 'turn' }">
        <h3>{ $player.opponentName || 'Their Board'}</h3>
        <Board board={game.opponentBoard} />
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
</style>