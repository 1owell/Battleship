<script>
    import { gameChat } from '../../BattleShipAPI';

    let message='';

    function handleKeyPress(e) {
        if (e.charCode === 13 && message) {
            gameChat(message);
            message = '';
        }
    }
</script>

<input type="text" bind:value={message} placeholder="Send tactical message..."
    on:keypress="{ handleKeyPress }">

<style>
    input {
        border-radius: 6px;
        height: 50px;
        width: 100%;
        max-width: 520px;
        background-color: #d8d8d824;
        color: white;
        margin: 15px;
    }

    input::placeholder {
        color: white;
    }

    input:focus {
        outline: none;
    }
</style>