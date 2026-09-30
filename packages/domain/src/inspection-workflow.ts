import {
  deriveInspectionResult,
  isInspectionComplete,
  type ChecklistItem,
  type Inspection,
  type InspectionAnswer,
  type Finding,
  type FindingSeverity
} from "./inspection.js";

export interface InspectionWorkflowInput {
  inspection: Inspection;
  requiredItems: ChecklistItem[];
  answers: InspectionAnswer[];
}

export interface InspectionWorkflowResult {
  inspection: Inspection;
  findings: Finding[];
}

export interface NewFindingInput {
  id: string;
  category: string;
  severity: FindingSeverity;
  description: string;
  normativeReference?: string;
  responsibleUserId?: string;
  now: Date;
}

export function completeInspection(
  input: InspectionWorkflowInput
): InspectionWorkflowResult {
  const complete = isInspectionComplete(
    { ...input.inspection, answers: input.answers },
    input.requiredItems
  );

  if (!complete) {
    throw new Error("INSPECTION_INCOMPLETE");
  }

  const result = deriveInspectionResult(input.answers);

  return {
    inspection: {
      ...input.inspection,
      answers: input.answers,
      completedAt: new Date(),
      result
    },
    findings: []
  };
}

export function addFinding(
  inspection: Inspection,
  finding: NewFindingInput
): Finding {
  if (!inspection.completedAt) {
    throw new Error("INSPECTION_NOT_COMPLETED");
  }

  return {
    id: finding.id,
    extinguisherId: inspection.extinguisherId,
    inspectionId: inspection.id,
    category: finding.category,
    severity: finding.severity,
    description: finding.description,
    normativeReference: finding.normativeReference,
    status: "ABERTA",
    responsibleUserId: finding.responsibleUserId,
    openedAt: finding.now
  };
}
