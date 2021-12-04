<script>
    import Board from "./Board.svelte";
    import ChatBox from "./ChatBox.svelte";
    import { game } from "./BoardStore";

</script>

<div class="game">
    <div class="player">
        <h3>Player 1 Name</h3>
        <Board board={game.playerBoard} />
        <ChatBox />
    </div>
    <div class="player">
        <h3>Player 2 Name</h3>
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
</style>