<script>
    import Cell from "./Cell.svelte";
    import ShipPiece from "./ShipPiece.svelte";
    
    export let board;

    const state = board.state;
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
        <p>Hits: 4</p>
        <p>Misses: 9</p>
        <p>Accuracy: 30%</p>
    </div>
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
    }

    .stats > p {
        flex: 1;
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

    .y {
        display: flex;
        flex-direction: column;
        justify-content: flex-end;
    }

    .y > p {
        margin: 14.5px;
    }
</style>