<script>
    import { chatMessages } from "../../Store";
    import { flip } from "svelte/animate";
    import { sendChat, respondToInvite } from "../../BattleShipAPI";

    let message;

    function formatDate(timestamp) {
        const date = new Date(timestamp * 1000);
        return date.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' });
    }

    function handleKeyPress(e) {
        if (e.charCode === 13 && message) {
            sendChat(message);
            message = '';
        }
    }
</script>

<div class="container">
    <input type="text" placeholder="Send a message" on:keypress={handleKeyPress} bind:value={message}>
    <div class="messages">
        {#each $chatMessages as message (message.id)}
            <div class="message" animate:flip="{{duration: 100}}">
                <div>{ formatDate(message.date) }</div>
                <div class="message-content">
                    {#if message.isInvite}
                        <div>{ message.username } has invited you to a game.</div>
                        <div>
                            <button class="confirm" on:click="{ () => respondToInvite(true, message.username)}">
                                Accept
                            </button>
                        </div>
                    {:else}
                        <div>{ message.username }</div>
                        <p>{ message.message }</p>
                    {/if}
                </div>
            </div>
        {/each}
    </div>
</div>

<style>
    .container {
        display: flex;
        flex-direction: column-reverse;
        border-radius: 6px;
        background-color: rgb(216, 216, 216, 0.3);
        height: 100%;
    }

    .message {
        margin: 5px 20px 5px 20px;
    }
    
    .messages {
        overflow-y: auto;
        overflow-x: hidden;
        display: flex;
        flex-direction: column-reverse;
    }

    .message-content {
        border-radius: 10px;
        background:rgba(80, 80, 80, 0.4);
        padding: 5px 10px 5px 10px;
        margin-top: 5px;
    }

    .message-content > div {
        color: #80ecff;
    }

    .message-content p {
        margin: 5px 0px 5px 0px;
    }

    .message-content button {
        color: white;
        border-radius: 6px;
        cursor: pointer;
        border: unset;
    }

    .confirm {
        background: rgba(139, 207, 139, 0.829);
    }

    .confirm:hover {
        background: rgba(100, 150, 100, 0.767);
    }

    .confirm:active {
        background: rgba(67, 100, 67, 0.767);
    }

    /* .deny {
        background: rgba(194, 123, 123, 0.932);
    }

    .deny:hover {
        background: rgba(151, 95, 95, 0.932);
    }

    .deny:active {
        background: rgba(112, 71, 71, 0.932);
    } */

    input {
        border-radius: 6px;
        height: 40px;
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