const dataReader = require("../../utils/dataReader");
const input = dataReader(__dirname);

function compareStrings(str1, str2) {
  // Storing index of indexes so that the index can be referenced later
  let mismatchedCharIndexes = [];
  str1.split("").forEach((char, index) => {
    if (char !== str2[index]) {
      mismatchedCharIndexes.push(index);

      // breaking out here to end loop early
      if (mismatchedCharIndexes.length > 1) {
        return;
      }
    }
  });
  return mismatchedCharIndexes;
}

input.forEach((originalStr, index) => {
  // Slicing to make sure it doesn't compare it to itself
  input.slice(index + 1).forEach(altStr => {
    let strIndexes = compareStrings(originalStr, altStr);

    // If only 1 index, that means only 1 has character is off.
    // Remove the character that was off from the string
    if (strIndexes.length === 1) {
      let str = originalStr.split("");
      str.splice(strIndexes[0], 1);
      console.log("Common Letters:", str.join(""));
    }
  });
});

/*
Time
real    0m0.094s
user    0m0.074s
sys     0m0.018s
*/
