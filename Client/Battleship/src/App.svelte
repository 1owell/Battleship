<script>
	import Lobby from "./Components/Lobby/Lobby.svelte";
	import { onMount } from "svelte";
	import { connect, connectToChat } from './BattleShipAPI';
	import { player } from './Store';
	import Game from "./Components/Game/Game.svelte";

	onMount(async () => {
		// connect();
		// connectToChat();
	});
</script>

<main>
	<Game />
	<!-- {#if $player.inGame}
		
	{:else}
		<Lobby />
	{/if} -->
</main>

<style>
	main {
		height: 90%;
	}
</style>