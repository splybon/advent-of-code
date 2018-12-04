const fs = require("fs");

// Requires dir input from relative file to get the path.  Directory must have input.txt file
function dataReader(dir) {
  const contents = fs.readFileSync(`${dir}/input.txt`, "utf8");
  // fs.close();
  return contents.split("\n");
}

module.exports = dataReader;
