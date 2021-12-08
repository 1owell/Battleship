<script>
    import Cell from "./Cell.svelte";
    import ShipPiece from "./ShipPiece.svelte";
    import { submitShips } from "../../BattleShipAPI";

    export let board;

    const state = board.state;

    async function checkShips() {
        const response = await submitShips(board.shipPositions);
        if (response.status == 200) {
            board.isSubmitted = true;
        }
    }
</script>

<div class="container">
    <div>
        <div class="y">
            {#each Array(10) as _, i}
                <p>{String.fromCharCode(i + 65)}</p>
            {/each}
        </div>

        <div class="board">
            {#each Array(10) as _, i}
                <p>{i + 1}</p>
            {/each}

            <svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">
                {#each $state.cells as cell, index}
                    <Cell cell={cell} index={index} isOpponent={ $state.ships == undefined } />
                {/each}

                {#each $state.ships ?? [] as ship}
                    <ShipPiece ship={ship} board={board} />
                {/each}
            </svg>
        </div>
    </div>

    <div class="stats">
        <p>Status Report</p>
        <p>Hits: { board.hits }</p>
        <p>Misses: { board.misses }</p>
        <p>Accuracy: { board.accuracyPercentage }%</p>
    </div>

    {#if !board.isSubmitted && $state.ships}
        <button on:click="{ checkShips }">Submit Ships</button>
    {/if}        
</div>


<style>
    p {
        font-weight: bold;
        color: white;
    }

    div {
        user-select: none;
    }

    .stats {
        display: flex;
        justify-content: space-between;
        width: 100%;
    }

    .stats > p {
        flex: 1;
    }

    .container {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .container > div {
        display: flex;
        justify-content: center;
    }

    .board {
        display: grid;
        grid-template-columns: repeat(10, 50px);
    }

    .board p {
        text-align: center;
    }
    
    button {
        border-radius: 6px;
        cursor: pointer;
        width: 50%;
    }

    .y {
        display: flex;
        flex-direction: column;
        justify-content: flex-end;
    }

    .y > p {
        margin: 14.5px;
    }
</style>