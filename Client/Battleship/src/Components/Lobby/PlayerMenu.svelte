<script>
    import { requestGame } from '../../BattleShipAPI';

    export let player;
</script>

<div class="container">
    <h5>{ player?.username ?? "No player selected" }</h5>
    {#if player}
        <div class="menu-btns">
            <button type="button" on:click="{ () => requestGame(player.username) }">Initiate Attack</button>
        </div>
    {/if}
</div>

<style>
    .container {
        background-color: rgba(216, 216, 216, .3);
        padding: 20px;
        border-radius: 6px;
    }

    .menu-btns {
        display: flex;
    }

    button {
        color: white;
        background: rgb(70, 70, 70);
        border-radius: 6px;
        border: unset;
        cursor: pointer;
    }

    button:hover {
        background: rgb(46, 46, 46);
        color: white;
    }

    button:active {
        background: rgb(22, 22, 22);
        color: white;
    }
</style>