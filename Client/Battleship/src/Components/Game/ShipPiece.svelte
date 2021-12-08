<script>
    // This ShipPiece component should only know about Ship related game state and presentation.
    // That includes [Ship hits, size, and presentation]
    export let board;
    export let ship;

    const shipStrokeWidth = 6;
    const cellWidth       = 50;
    const length          = cellWidth * ship.size - (shipStrokeWidth * 2);
    const thickness       = 35;

    const x = () => cellWidth / 2;
    const y = (i) => 20 + (i * cellWidth);
    
    let moving = false;

    $: left = (ship.origin.x - 1) * cellWidth;
    $: top  = (ship.origin.y - 1) * cellWidth - (ship.isVertical ? 0 : 50);

    $: shipLength = ship.isVertical ? length : thickness;
    $: shipWidth  = ship.isVertical ? thickness : length;

    $: shipX = (i) => ship.isVertical ? x() : y(i);
    $: shipY = (i) => ship.isVertical ? y(i) : x();

    function start() {
        moving = true;
    }

    function stop() {
        if (moving) {
            moving = false;
            board.stoppedDragging(ship, left, top);
        }  
    }

    function move(e) {
        if (moving) {
            left += e.movementX;
            top += e.movementY;
        }
    }

    function rotate(e) {
        if (e.keyCode == 32 && moving) {
            ship.isVertical = !ship.isVertical;
        }
    }
</script>


<svelte:window on:mouseup={stop} on:mousemove={move} on:keyup={rotate} />

<g on:mousedown={start} transform="translate({left}, {top})">
    <rect fill={ ship.isValid ? "lightgray" : "pink" } x="7.5" y="2" rx="10" ry="10" 
        width={ shipWidth } height={ shipLength }
        stroke={ ship.isValid ? "gray" : "red" } stroke-width={shipStrokeWidth}/>

    {#each Array(ship.size) as _, i}
        <circle fill="gray" 
            cx={ shipX(i) } cy={ shipY(i) } r="10"
            stroke="darkgray"
            stroke-width="4" />
    {/each}
</g>


<style>
    g:hover {
        cursor: move;
    }
</style>