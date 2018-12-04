const dataReader = require("../../utils/dataReader");
const input = dataReader(__dirname);

// Sums the input starting with 0
const frequency = input.reduce((x, y) => x + parseInt(y), 0);

console.log("frequency:", frequency);

/*
Time
real    0m0.072s
user    0m0.054s
sys     0m0.016s
*/
