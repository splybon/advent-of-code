const dataReader = require("../../utils/dataReader");
const input = dataReader(__dirname, "input.txt");
const coordinates = input.map(row => row.split(",").map(num => parseInt(num)));

let boundaries = {};
let infiniteCoordinates = [];
let finiteCoordinatesStr = [];

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

// Will detect if the array contains multiple of an item
function arrayContainsMultiple(array, equalityMeasure) {
  let count = 0;
  array.forEach(item => {
    if (item === equalityMeasure) {
      count++;
    }
  });
  return count > 1;
}

// Finds the closest coordinate of the original ones
// If there are multiple it errors out
function findClosestCoord(xInput, yInput) {
  let foundCoord = coordinates[0];
  let foundCoordDistance =
    Math.abs(xInput - coordinates[0][0]) + Math.abs(yInput - coordinates[0][1]);
  let distances = [foundCoordDistance];
  coordinates.slice(1).map(coord => {
    const [x, y] = coord;
    const distance = Math.abs(x - xInput) + Math.abs(y - yInput);
    if (distance < foundCoordDistance) {
      foundCoord = coord;
      foundCoordDistance = distance;
    }
    distances.push(distance);
  });
  if (arrayContainsMultiple(distances, foundCoordDistance)) {
    throw "multiple found distances";
  }
  return foundCoord;
}

// If coordinate is touching a boundary then it must go on infinitely.
// Mark those in the infinite class
function findCoordinatesFromBoundary(starting, ending, alternateLine, xCoord) {
  for (i = starting; i <= ending; i++) {
    try {
      // Using str b/c later arary.includes wasn't working with a 2c array
      const coord = xCoord
        ? findClosestCoord(i, alternateLine).join("-")
        : findClosestCoord(alternateLine, i).join("-");
      if (!infiniteCoordinates.includes(coord)) {
        infiniteCoordinates.push(coord);
      }
    } catch (e) {}
  }
}

// Looping through each boundary to mark coords as infinite
function determineInfiniteCoords() {
  const { minX, maxX, minY, maxY } = boundaries;
  findCoordinatesFromBoundary(minX, maxX, minY, true);
  findCoordinatesFromBoundary(minX, maxX, maxY, true);
  findCoordinatesFromBoundary(minY, maxY, minX, false);
  findCoordinatesFromBoundary(minY, maxY, maxX, false);
}

// returns diff of original and infinite
// Using str b/c later arary.includes wasn't working with a 2c array
function determineFiniteCoords() {
  const stringCoords = coordinates.map(coord => coord.join("-"));
  finiteCoordinatesStr = stringCoords.filter(
    i => infiniteCoordinates.indexOf(i) < 0
  );
}

function generateMaxAreaObj() {
  const { minX, maxX, minY, maxY } = boundaries;
  let coordObj = {};
  for (x = minX; x <= maxX; x++) {
    for (y = minY; y <= maxY; y++) {
      try {
        const coord = findClosestCoord(x, y).join("-");
        if (finiteCoordinatesStr.includes(coord)) {
          coordObj[coord] = (coordObj[coord] || 0) + 1;
        }
      } catch (e) {}
    }
  }
  return coordObj;
}

function findMaxArea(obj) {
  return Object.keys(obj).reduce((acc, key) => {
    if (obj[key] > acc) {
      acc = obj[key];
    }
    return acc;
  }, 0);
}

/*
The Plan!

1. Generate the boundaries for the grid by finding the min/max x,y coordinates.
2. Determine which coordinates are infinite by seeing if a line
   on the boundary is closest to a coordinate
3. For the finite coordinates, calculate the closest area around them
4. Find the max of those areas
*/

findBoundaries();
determineInfiniteCoords();
determineFiniteCoords();
const obj = generateMaxAreaObj();
const max = findMaxArea(obj);
console.log("Max Area: ", max);

/*
real    0m0.206s
user    0m0.182s
sys     0m0.024s
*/
