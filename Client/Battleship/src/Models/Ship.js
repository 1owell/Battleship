export class Ship {

    constructor(name, size, x) {
        this.name = name;
        this.size = size;
        this.hits = [];
        this.isVertical = true;
        this.origin = {x: x, y: 1}
        this.isValid = true;
    }

    get points() {
        return Array.from(Array(this.size), (_, i) => {
            return {
                x: this.isVertical ? this.origin.x : i + this.origin.x,
                y: this.isVertical ? i + this.origin.y : this.origin.y
            }
        });
    }

    get cells() {
        
    }

    hit(pos) {
        if (pos <= this.size && !this.hits.includes(pos)) {
            this.hits.push(pos);
        }
    }

    toggleOrientation() {
        this.isVertical = !this.isVertical;
    }

    isOverlapping(otherShip) {
        const combined = [...this.points, ...otherShip.points];
        const distinct = new Set(combined.map(JSON.stringify));
        
        console.log(combined, distinct)
        console.log(this.name, 'is overlapping with', otherShip.name, distinct.size < combined.length)
        
        return distinct.size < combined.length;
    }
}