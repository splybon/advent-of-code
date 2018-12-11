const dataReader = require("../../utils/dataReader");
const input = dataReader(__dirname, "input.txt");
let points = [];
let boundaries = {};
let positions = {};
const minimumDrawingSizeWindow = 100;

// Initializes points from the input
function populatePoints() {
  const regex = /n=<(.+)> v.+<(.+)>/;
  input.forEach(point => {
    if (!point) {
      return;
    }
    const [position, velocity] = point
      .match(regex)
      .slice(1, 3)
      .map(str => str.split(",").map(coord => parseInt(coord)));
    points.push({
      position,
      velocity,
    });
  });
}

// Calculates boundaries so that the window can be drawn later
function calculateBoundaries() {
  const [xCoords, yCoords] = points.reduce(
    (acc, point) => {
      const [x, y] = point.position;
      acc[0].push(x);
      acc[1].push(y);
      positions[`${x},${y}`] = true;
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

function drawPoints() {
  // Looping through bounds to draw the points
  for (y = boundaries.minY - 1; y < boundaries.maxY + 2; y++) {
    let arrayForDrawing = [];
    for (x = boundaries.minX - 1; x < boundaries.maxX + 2; x++) {
      const character = positions[`${x},${y}`] ? "#" : ".";
      arrayForDrawing.push(character);
    }
    console.log(arrayForDrawing.join(""));
  }
  console.log("\n");
}

function addVelocity() {
  Object.keys(points).forEach(key => {
    const point = points[key];
    const { position, velocity } = point;
    points[key].position = [
      position[0] + velocity[0],
      position[1] + velocity[1],
    ];
  });
}

populatePoints();

let finishedLoop = false;
let previousXDiff = Infinity;
let second = 0;

while (!finishedLoop) {
  calculateBoundaries();
  const currentXDiff = boundaries.maxX - boundaries.minX;
  if (currentXDiff < minimumDrawingSizeWindow) {
    console.log("drawing for count:", second);
    drawPoints();
  }
  addVelocity();
  positions = {};

  // Checking for when the loop should finish.  If the screen starts expanding
  if (currentXDiff > previousXDiff) {
    finishedLoop = true;
  }
  previousXDiff = currentXDiff;
  second++;
}

/*
This was probably the easiest puzzle to solve this whole time.
Just adding a count to my already existing setup.

real  0m3.774s
user  0m4.314s
sys 0m0.177s
*/
