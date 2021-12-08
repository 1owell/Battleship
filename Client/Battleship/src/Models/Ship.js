export class Ship {

    constructor(name, size, initialPos) {
        this.name       = name;
        this.size       = size;
        this.hits       = [];
        this.isVertical = true;
        this.origin     = initialPos;
        this.isValid    = true;
    }

    get cells() {
        if (this.isVertical) {
            return Array(this.size).fill().map((_, i) => this.origin + (i * 10));
        } else {
            return Array(this.size).fill().map((_, i) => this.origin + i);
        }
    }

    get row() {
        return Math.ceil(this.origin / 10);
    }

    get col() {
        const col = this.origin % 10;
        return col == 0 ? 10 : col;
    }

    toggleOrientation() {
        this.isVertical = !this.isVertical;
    }
}