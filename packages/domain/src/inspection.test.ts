import test from "node:test";
import assert from "node:assert/strict";
import { deriveInspectionResult, isInspectionComplete, type ChecklistItem } from "./inspection.js";

const items: ChecklistItem[] = [
  { id: "1", code: "01", description: "Acesso desobstruído", required: true },
  { id: "2", code: "02", description: "Lacre íntegro", required: true }
];

test("inspeção só fica completa quando todos os itens obrigatórios foram respondidos", () => {
  assert.equal(isInspectionComplete({
    id: "i1",
    extinguisherId: "e1",
    operatorId: "u1",
    checklistVersion: "1.0",
    startedAt: new Date(),
    result: "INCONCLUSIVA",
    answers: [{ checklistItemId: "1", result: "CONFORME" }]
  }, items), false);

  assert.equal(isInspectionComplete({
    id: "i1",
    extinguisherId: "e1",
    operatorId: "u1",
    checklistVersion: "1.0",
    startedAt: new Date(),
    result: "INCONCLUSIVA",
    answers: [
      { checklistItemId: "1", result: "CONFORME" },
      { checklistItemId: "2", result: "CONFORME" }
    ]
  }, items), true);
});

test("qualquer item não conforme torna a inspeção não conforme", () => {
  assert.equal(deriveInspectionResult([
    { checklistItemId: "1", result: "CONFORME" },
    { checklistItemId: "2", result: "NAO_CONFORME" }
  ]), "NAO_CONFORME");
});

test("inspeção sem respostas permanece inconclusiva", () => {
  assert.equal(deriveInspectionResult([]), "INCONCLUSIVA");
});
