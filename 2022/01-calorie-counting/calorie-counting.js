let result = 
    require("fs").readFileSync("./input", "utf8")
        .split("\n\n")
        .map(elf => elf.split("\n"))
        .map(elf => elf.reduce((sum, calories) => { return sum += parseInt(calories) }, 0))
        .sort((a, b) => { return b - a })

console.log(
    result[0], // 69206
    result[0] + result[1] + result[2] // 197400
)
