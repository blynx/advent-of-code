let store = { prios: {}, group: [], sum: 0, groupSum: 0 }

for (let p = 1; p <= 26; p++) {
    store.prios[String.fromCodePoint(96 + p)] = p      // codepoint a = 97
    store.prios[String.fromCodePoint(64 + p)] = p + 26 // codepoint A = 65
}

function makeRucksackInspector(store) {
    return function(line) {
        // find common type in compartments
        let left = line.slice(0, line.length / 2)
        let right = line.slice(line.length / 2, line.length)
        for (let char of right) {
            if (left.includes(char)) {
                store.sum += store.prios[char]; break
            }
        }
        // find common type in groups
        if (store.group.length < 2) {
            store.group.push(line)
        } else {
            for (let char of line) {
                if (store.group[0].includes(char) && store.group[1].includes(char)) {
                    store.groupSum += store.prios[char]; break
                }
            }
            store.group = []
        }
    }
}

require("readline").createInterface({
    input: require("fs").createReadStream("./input"),
    output: process.stdout,
    terminal: false
})
.on("line", makeRucksackInspector(store))
.on("close", () => console.log("Result:", store.sum, store.groupSum))
