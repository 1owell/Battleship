<script>
    // This ShipPiece component should only know about Ship related game state and presentation.
    // That includes [Ship hits, size, and presentation]

    export let ship;

    const shipStrokeWidth = 6;
    const length          = 50 * ship.size - (shipStrokeWidth * 2);
    const thickness       = 35;
    const cellWidth       = 50;
</script>

<rect fill={ ship.isValid ? "lightgray" : "pink" } x="7.5" y="2" rx="10" ry="10" 
        width={ thickness } height={ length }
        stroke={ ship.isValid ? "gray" : "red" } stroke-width={shipStrokeWidth}/>

{#each Array(ship.size) as _, i}
    <circle fill="gray" 
        cx={ cellWidth / 2 } cy={ 20 + (i * cellWidth) } r="10"
        stroke="darkgray"
        stroke-width="4" />
{/each}

