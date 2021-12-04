<script>
    import { game } from './BoardStore';

    export let cell;
    export let isOpponent;

    const index = cell.index;

    let x = 50 * (index % 10) + 25;
    let y = 50 * Math.floor(index / 10) + 20;

    function attack() {
        if (isOpponent) {
            game.attack(index);
        }   
    }
</script>

<circle class:isOpponent on:click={ attack }
    fill={ cell.isHit ? "red" : "lightblue" } 
    cx="{ x }" 
    cy="{ y }" 
    r="18"
    stroke="lightcyan"
    stroke-width="4"
/>

<style>
    circle.isOpponent:hover {
        opacity: 0.3;
    }
</style>