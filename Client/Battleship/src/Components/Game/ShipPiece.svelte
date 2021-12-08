<script>
    import { player } from '../../Store';
    
    export let board;
    export let ship;

    const shipStrokeWidth = 6;
    const cellWidth       = 50;
    const length          = cellWidth * ship.size - (shipStrokeWidth * 2);
    const thickness       = 35;

    let moving = false;
    let didRotate = false;

    
    $: isVertical = ship.isVertical;
    $: left = (ship.col - 1) * cellWidth;
    $: top  = (ship.row - 1) * cellWidth;
    $: shipLength = isVertical ? length : thickness;
    $: shipWidth  = isVertical ? thickness : length;

    function start() {
        if (!board.isSubmitted) {
            moving = true;
        }
    }

    function stop() {
        if (moving) {
            board.stoppedDragging(ship, left, top, didRotate);
            moving = false;
            didRotate = false;
            ship.isVertical = isVertical;
            
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
            isVertical = !isVertical;
            didRotate = !didRotate;
        }
    }

    $: cx = (i) => {
        if (isVertical) {
            return cellWidth / 2;
        } else {
            return (cellWidth / 2) + (i * cellWidth);
        }
    }

    $: cy = (i) => {
        if (isVertical) {
            return 20 + (i * cellWidth);
        } else {
            return 20;
        }
    }

    $: color = (i) => {
        board.$state;
        return board.isHit(ship.cells[i]) ? 'red' : 'gray';
    }
</script>

<svelte:window on:mouseup={stop} on:mousemove={move} on:keyup={rotate} />

<g on:mousedown={start} transform="translate({left}, {top})">
    <rect fill={ ship.isValid ? "lightgray" : "pink" } x="7.5" y="2" rx="10" ry="10" 
        width={ shipWidth } height={ shipLength }
        stroke={ ship.isValid ? "gray" : "red" } stroke-width={shipStrokeWidth}/>

    {#each Array(ship.size) as _, i}
        <circle fill="{ color(i) }" 
            cx={ cx(i) } cy={ cy(i) } r="10"
            stroke="darkgray"
            stroke-width="4" />
    {/each}
</g>


<style>
    g:hover {
        cursor: move;
    }
</style>