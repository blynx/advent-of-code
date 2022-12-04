// Them Me: Shape       Points
// A    X : Rock        1
// B    Y : Paper       2
// C    Z : Scissors    3

// Lose: 0
// Draw: 3
// Win:  6

function match1(vs) {
    switch (vs) {
        case "A X": return 3 + 1;
        case "A Y": return 6 + 2;
        case "A Z": return 0 + 3;

        case "B X": return 0 + 1;
        case "B Y": return 3 + 2;
        case "B Z": return 6 + 3;

        case "C X": return 6 + 1;
        case "C Y": return 0 + 2;
        case "C Z": return 3 + 3;
        default: return 0;
    }
}

// X: need to lose
// Y: need to draw
// Z: need to win

function match2(vs) {
    switch (vs) {
        case "A X": return 0 + 3;
        case "A Y": return 3 + 1;
        case "A Z": return 6 + 2;

        case "B X": return 0 + 1;
        case "B Y": return 3 + 2;
        case "B Z": return 6 + 3;

        case "C X": return 0 + 2;
        case "C Y": return 3 + 3;
        case "C Z": return 6 + 1;
        default: return 0;
    }
}

let result = require("fs").readFileSync("./input.txt", "utf8")
    .split("\n")
    .reduce(([sum1, sum2], vs) => [sum1 += match1(vs), sum2 += match2(vs)], [0, 0])

console.log(result)
