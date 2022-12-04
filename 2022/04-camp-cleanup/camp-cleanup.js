const input = require("fs").readFileSync("./input.txt", "utf8")

let fullyOverlappingPairs = 0
let overlappingPairs = 0

for (const pair of input.split("\n")) {
    if (pair.length == 0) continue
    const [ls, le, rs, re] = pair.match(/(\d\d?)/g).map(s => parseInt(s))
    if (ls <= rs && le >= re || ls >= rs && le <= re) {
        fullyOverlappingPairs += 1
        overlappingPairs += 1
    } else if (le >= rs && le <= re || re >= ls && re <= le) {
        overlappingPairs += 1
    }
}

console.log("Results:", fullyOverlappingPairs, overlappingPairs)
