<script>
    import { stoppedDragging } from './BoardStore';

    export let state;
    export let ship;

    let isVertical = ship.isVertical;
    let moving = false;
    const cellWidth = 50;

    $: left   = (ship.origin.x - 1) * cellWidth;
    $: top    = (ship.origin.y - 1) * cellWidth;

    function start() {
        moving = true;
    }

    function stop() {
        if (moving) {
            moving = false;
            //stoppedDragging(ship, left, top);

            // update the ship model with the orientation
            

            // need to check with the board's state to see if the cells are available
            // for (const aship of ships) {
            //     if (aship.name !== ship.name) {
            //         if (ship.isOverlapping(aship)) {
            //             ship.isValid = false;
            //         }
            //     }
            // }
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
        }
    }
</script>

<svelte:window on:mouseup={stop} on:mousemove={move} on:keyup={rotate} />
<g on:mousedown={start} transform="translate({left}, {top}) rotate({ isVertical ? 0 : -90 } {cellWidth} {cellWidth})">
    <slot></slot>
</g>

<style>
    g:hover {
        cursor: move;
    }
</style>