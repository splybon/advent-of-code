const dataReader = require("../../utils/dataReader");
const gridSerialNumber = parseInt(dataReader(__dirname, "input.txt"));
const boundaries = { minX: 1, maxX: 300, minY: 1, maxY: 300 };
let grid = [];

function calculatePowerLevel(x, y) {
  const rackId = x + 10;
  let powerLevel = rackId * y;
  powerLevel += gridSerialNumber;
  powerLevel *= rackId;
  const hundredsPlace = parseInt(powerLevel.toString().slice(-3)[0]);
  return hundredsPlace - 5;
}

function populateGrid() {
  for (y = boundaries.minY; y <= boundaries.maxY; y++) {
    let row = [];
    for (x = boundaries.minX; x <= boundaries.maxX; x++) {
      const value = calculatePowerLevel(x, y);
      row[x] = value;
    }
    grid[y] = row;
  }
}

function findlargestTotalPower() {
  let max = 0;
  let totalX = 0;
  let totalY = 0;
  for (y = boundaries.minY; y <= boundaries.maxY - 2; y++) {
    for (x = boundaries.minX; x <= boundaries.maxX - 2; x++) {
      let sum = 0;
      grid[y].slice(x, x + 3).forEach(num => (sum += num));
      grid[y + 1].slice(x, x + 3).forEach(num => (sum += num));
      grid[y + 2].slice(x, x + 3).forEach(num => (sum += num));
      if (sum > max) {
        max = sum;
        totalX = x;
        totalY = y;
      }
    }
  }
  console.log(`max ${max} for x,y ${totalX},${totalY}`);
}

populateGrid();
findlargestTotalPower();
