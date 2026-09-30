import test from "node:test";
import assert from "node:assert/strict";
import { completeInspection, addFinding } from "./inspection-workflow.js";
import type { Inspection } from "./inspection.js";

const baseInspection: Inspection = {
  id: "insp-1",
  extinguisherId: "ext-1",
  operatorId: "user-1",
  checklistVersion: "1.0",
  startedAt: new Date("2026-09-27T10:00:00Z"),
  result: "INCONCLUSIVA",
  answers: []
};

const items = [
  { id: "item-1", code: "01", description: "Acesso livre", required: true },
  { id: "item-2", code: "02", description: "Lacre íntegro", required: true }
];

test("não permite concluir checklist incompleto", () => {
  assert.throws(() => completeInspection({
    inspection: baseInspection,
    requiredItems: items,
    answers: [{ checklistItemId: "item-1", result: "CONFORME" }]
  }), { message: "INSPECTION_INCOMPLETE" });
});

test("conclusão registra data e resultado", () => {
  const result = completeInspection({
    inspection: baseInspection,
    requiredItems: items,
    answers: [
      { checklistItemId: "item-1", result: "CONFORME" },
      { checklistItemId: "item-2", result: "NAO_CONFORME" }
    ]
  });

  assert.ok(result.inspection.completedAt);
  assert.equal(result.inspection.result, "NAO_CONFORME");
});

test("não permite abrir irregularidade antes da conclusão", () => {
  assert.throws(() => addFinding(baseInspection, {
    id: "find-1",
    category: "ACESSO",
    severity: "ALTA",
    description: "Extintor obstruído",
    now: new Date()
  }), { message: "INSPECTION_NOT_COMPLETED" });
});

test("irregularidade preserva o vínculo com inspeção e extintor", () => {
  const completed = completeInspection({
    inspection: baseInspection,
    requiredItems: items,
    answers: [
      { checklistItemId: "item-1", result: "NAO_CONFORME" },
      { checklistItemId: "item-2", result: "CONFORME" }
    ]
  }).inspection;

  const finding = addFinding(completed, {
    id: "find-1",
    category: "ACESSO",
    severity: "CRITICA",
    description: "Extintor obstruído",
    normativeReference: "ICA 92-20",
    responsibleUserId: "responsible-1",
    now: new Date("2026-09-27T10:15:00Z")
  });

  assert.equal(finding.inspectionId, "insp-1");
  assert.equal(finding.extinguisherId, "ext-1");
  assert.equal(finding.status, "ABERTA");
});
