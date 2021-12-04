class Cell {

    static State = {
        Attacked: 'Attacked',
        Hit: 'Hit',
        Neutral: 'Neutral'
    }

    constructor(index) {
        this.index = index;
        this.state = Cell.State.Neutral;
    }

    registerAttack(didHit) {
        this.state = didHit ? Cell.State.Hit : Cell.State.Attacked;
    }
}