const fs = require("fs");

// Requires dir input from relative file to get the path.  Directory must have input.txt file
function dataReader(dir, file = "input.txt") {
  const contents = fs.readFileSync(`${dir}/${file}`, "utf8");
  return contents.split("\n");
}

module.exports = dataReader;

// Use Case
/*
const dataReader = require("../../utils/dataReader");
const input = dataReader(__dirname);
*/
