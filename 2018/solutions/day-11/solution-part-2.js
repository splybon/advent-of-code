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

// Looping through to start calculations for each
function findlargestTotalPower() {
  let totalMax = 0;
  let totalX = 0;
  let totalY = 0;
  let totalSize = 0;
  for (y = boundaries.minY; y <= boundaries.maxY - 2; y++) {
    console.log(`${Math.round((y / 300.0) * 100)}% complete`);
    for (x = boundaries.minX; x <= boundaries.maxX - 2; x++) {
      [sum, size] = findMaxForCoord(x, y);
      if (sum > totalMax) {
        totalMax = sum;
        totalSize = size;
        totalX = x;
        totalY = y;
      }
    }
  }
  console.log("x,y,size: ", `${totalX},${totalY},${totalSize}`);
}

// Calculate all possible square sizes for a particular coordinate
function findMaxForCoord(xCoord, yCoord) {
  let sum = 0;
  let totalSize;
  const maxSquareSize = Math.min(
    boundaries.maxY - 2 - yCoord,
    boundaries.maxX - 2 - xCoord
  );

  if (maxSquareSize < 1) {
    return [0, 0];
  }
  for (squareSize = 1; squareSize <= maxSquareSize; squareSize++) {
    let currentSum = 0;
    // Using yy instead of y b/c of function scope
    for (yy = yCoord; yy <= yCoord + squareSize; yy++) {
      for (xx = xCoord; xx <= xCoord + squareSize; xx++) {
        // console.log("grid spot", grid[yy][xx]);
        currentSum += grid[yy][xx];
      }
    }
    if (currentSum > sum) {
      sum = currentSum;
      totalSize = squareSize + 1;
    }
  }
  return [sum, totalSize];
}

populateGrid();
findlargestTotalPower();
// [s, p] = findMaxForCoord(90, 269);
// console.log(s, p);
