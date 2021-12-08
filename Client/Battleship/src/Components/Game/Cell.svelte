<script>
    import { attack } from '../../BattleShipAPI';
    import { player } from '../../Store';

    export let cell;
    export let index;
    export let isOpponent;

    let x = 50 * (index % 10) + 25;
    let y = 50 * Math.floor(index / 10) + 20;

    function attemptAttack() {
        if (isOpponent && $player.turnActive && !$player.game.opponentBoard.isHit(cell + 1)) {
            attack(index + 1);
        }   
    }

    $: color = () => {
        if (cell == 2) {
            return "red";
        } else if (cell == 1) {
            return "white";
        } else {
            return "lightblue";
        }
    }
</script>

<circle class:isOpponent on:click={ attemptAttack }
    fill="{ color() }" 
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