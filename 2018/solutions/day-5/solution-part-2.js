const dataReader = require("../../utils/dataReader");
const input = dataReader(__dirname)[0];
const alphabet = "abcdefghijklmnopqrstuvwxyz";
// Looks like aA|Aa|bB|Bb etc...
const regexStr = alphabet
  .split("")
  .reduce(
    (acc, char) =>
      acc + `${char}${char.toUpperCase()}|${char.toUpperCase()}${char}|`,
    ""
  )
  .slice(0, -1);
let minimumPolymerLength = input.length;

function reducePolymer(polymer) {
  const originalPolymerLength = polymer.length;
  polymer = polymer.replace(new RegExp(regexStr, "g"), "");
  if (originalPolymerLength === polymer.length) {
    if (polymer.length < minimumPolymerLength) {
      minimumPolymerLength = polymer.length;
    }
  } else {
    reducePolymer(polymer);
  }
}

// Running similar code to solution 1, but just removing a char each time
alphabet.split("").forEach(char => {
  const formattedInput = input.replace(new RegExp(char, "gi"), "");
  reducePolymer(formattedInput);
});
console.log("Minimum Polymer Length: ", minimumPolymerLength);

/*
real	0m1.270s
user	0m1.247s
sys	0m0.048s
*/
