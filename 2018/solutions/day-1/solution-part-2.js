const dataReader = require("../../utils/dataReader");
const input = dataReader(__dirname);

let frequency = 0;
let duplicateFrequency;

// Choosing mapping over array b/c it needs to loop through the inputs many times
let numMap = {};

while (!duplicateFrequency) {
  input.forEach(numStr => {
    // Exiting from loop if frequency is found
    if (duplicateFrequency) {
      return;
    }

    // Summing the frequency accumulator
    frequency += parseInt(numStr);

    // If frequency is found in the map, we will exit the loop after this iteration
    // Else we store the newFrequency in the hash
    if (numMap[frequency]) {
      duplicateFrequency = frequency;
    } else {
      numMap[frequency] = "stored";
    }
  });
}

console.log("found frequency", duplicateFrequency);

/*
Time
real    0m0.113s
user    0m0.091s
sys     0m0.022s
*/
