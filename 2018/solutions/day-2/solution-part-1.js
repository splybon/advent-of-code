const dataReader = require("../../utils/dataReader");
const input = dataReader(__dirname);

// Keeping track of the different count of words with these types of letters
let twoLetterCount = 0;
let threeLetterCount = 0;

function processInput(str) {
  let twoLetter, threeLetter;
  let charMap = {};
  const array = str.split("");

  // Storing each char in an object to keep track of the
  array.forEach(function(char) {
    charMap[char] = (charMap[char] || 0) + 1;
  });

  // Look at the map to find the characters with a 2 or a 3
  // Assign those to vars so even if it happens multiple times it will only be coiunted once
  Object.keys(charMap).forEach(function(key) {
    if (charMap[key] === 2) {
      twoLetter = true;
    } else if (charMap[key] >= 3) {
      threeLetter = true;
    }
  });

  // Assigning the letter count based on if it was found when looping over the map
  if (twoLetter) {
    twoLetterCount++;
  }
  if (threeLetter) {
    threeLetterCount++;
  }
}

// Start by looping through each input for processing
input.forEach(processInput);
console.log("checksum is: ", twoLetterCount * threeLetterCount);

/*
Time
real    0m0.079s
user    0m0.062s
sys     0m0.017s
*/
