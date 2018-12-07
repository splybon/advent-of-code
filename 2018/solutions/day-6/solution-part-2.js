const dataReader = require("../../utils/dataReader");
const input = dataReader(__dirname, "input.txt");
const coordinates = input.map(row => row.split(",").map(num => parseInt(num)));

let boundaries = {};
let regionCount = 0;
const distanceMax = 10000;

function findBoundaries() {
  const [xCoords, yCoords] = coordinates.reduce(
    (acc, coord) => {
      const [x, y] = coord;
      acc[0].push(x);
      acc[1].push(y);
      return acc;
    },
    [[], []]
  );
  Object.assign(boundaries, {
    minX: Math.min(...xCoords),
    maxX: Math.max(...xCoords),
    minY: Math.min(...yCoords),
    maxY: Math.max(...yCoords),
  });
}

// Finds the closest coordinate of the original ones
// If there are multiple it errors out
function findClosestCoordDistance(xInput, yInput) {
  let coordDistance = 0;
  coordinates.forEach(coord => {
    const [x, y] = coord;
    const distance = Math.abs(x - xInput) + Math.abs(y - yInput);
    coordDistance += distance;
  });
  return coordDistance;
}

function calculateMaxArea() {
  const { minX, maxX, minY, maxY } = boundaries;
  let coordObj = {};
  for (x = minX; x <= maxX; x++) {
    for (y = minY; y <= maxY; y++) {
      const distance = findClosestCoordDistance(x, y);
      if (distance < distanceMax) {
        regionCount++;
      }
    }
  }
  return coordObj;
}

findBoundaries();
calculateMaxArea();
console.log("count", regionCount);

/*
real    0m0.114s
user    0m0.091s
sys     0m0.019s
*/
