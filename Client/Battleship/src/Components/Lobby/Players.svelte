<script>
    import { onMount } from 'svelte';
    import { getPlayers } from '../../BattleShipAPI';
    import { flip } from 'svelte/animate';
    import { players } from '../../Store';

    onMount(async () => refresh());

    export let selectedPlayer = undefined;


    async function refresh() {
        await getPlayers();
        setTimeout(refresh, 5000);
    }

    function selectPlayer(player) {
        if (selectedPlayer == player) {
            selectedPlayer = undefined;
        } else {
            selectedPlayer = player;
        }
    }
</script>

<div>
    <h4>Players Online - { $players.length }</h4>
    <div class="container">
        {#each $players as player (player.username)}
            <div class="player { player.username == selectedPlayer?.username ? 'selected' : '' }" 
                 on:click="{ () => selectPlayer(player) }"
                 animate:flip="{{duration: 300}}">
                <span>{player.username}</span>
            </div>
        {:else}
            <div></div>
            <div class="label">No Players Online</div>
            <div></div>
        {/each}
    </div>
</div>


<style>
    .label {
        text-align: center;
    }

    .container {
        display: grid;
        grid-template-columns: 1fr 1fr 1fr;
        gap: 10px;
        background-color: rgba(216, 216, 216, .3);
        padding: 20px;
        overflow-y: auto;
        border-radius: 8px;
        max-height: 500px;
    }

    .player {
        display: flex;
        height: 50px;
        align-items: center;
        justify-content: center;
        background-color: rgba(60, 58, 85, 0.7);
        border-radius: 4px;
        cursor: pointer;
        user-select: none;
    }

    .selected {
        outline: 2px solid darkblue;
        box-shadow: 5px 5px 10px black;
    }
</style>