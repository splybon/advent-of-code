const dataReader = require("../../utils/dataReader");
const input = dataReader(__dirname);

// Lol.  Using this to compare against the polymer
const regexStr =
  "aA|Aa|bB|Bb|cC|Cc|dD|Dd|eE|Ee|fF|Ff|gG|Gg|hH|Hh|iI|Ii|jJ|Jj|kK|Kk|lL|Ll|mM|Mm|nN|Nn|oO|Oo|pP|Pp|qQ|Qq|rR|Rr|sS|Ss|tT|Tt|uU|Uu|vV|Vv|wW|Ww|xX|Xx|yY|Yy|zZ|Zz";

// Recursviely looping through removing from the polymer string until nothing more can be removed
function reducePolymer(polymer) {
  const originalPolymerLength = polymer.length;
  // removing anything in the polymer matching the regex
  polymer = polymer.replace(new RegExp(regexStr, "g"), "");

  if (originalPolymerLength === polymer.length) {
    console.log("Final Polymer Length", polymer.length);
  } else {
    reducePolymer(polymer);
  }
}

reducePolymer(input[0]);

/*
real	0m0.139s
user	0m0.104s
sys	0m0.026s
*/
