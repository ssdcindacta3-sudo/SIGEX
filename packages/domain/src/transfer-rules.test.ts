import test from "node:test";
import assert from "node:assert/strict";
import { canTransfer, type UnitType } from "./transfer-rules.js";

const cases: Array<[UnitType, UnitType, boolean]> = [
  ["CINDACTA_III", "CINDACTA_III", true],
  ["CINDACTA_III", "DTCEA", true],
  ["DTCEA", "CINDACTA_III", true],
  ["DTCEA", "DTCEA", false]
];

for (const [origin, destination, expected] of cases) {
  test(`transfer ${origin} -> ${destination}`, () => {
    assert.equal(canTransfer({ unitType: origin }, { unitType: destination }), expected);
  });
}
