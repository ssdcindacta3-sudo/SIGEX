export type InspectionResult = "CONFORME" | "NAO_CONFORME" | "INCONCLUSIVA";
export type FindingSeverity = "BAIXA" | "MEDIA" | "ALTA" | "CRITICA";
export type FindingStatus = "ABERTA" | "EM_TRATAMENTO" | "RESOLVIDA" | "CANCELADA";

export interface ChecklistItem {
  id: string;
  code: string;
  description: string;
  required: boolean;
}

export interface InspectionAnswer {
  checklistItemId: string;
  result: "CONFORME" | "NAO_CONFORME" | "NAO_APLICAVEL";
  observation?: string;
}

export interface Inspection {
  id: string;
  extinguisherId: string;
  operatorId: string;
  checklistVersion: string;
  startedAt: Date;
  completedAt?: Date;
  result: InspectionResult;
  answers: InspectionAnswer[];
}

export interface Finding {
  id: string;
  extinguisherId: string;
  inspectionId: string;
  category: string;
  severity: FindingSeverity;
  description: string;
  normativeReference?: string;
  status: FindingStatus;
  responsibleUserId?: string;
  openedAt: Date;
  closedAt?: Date;
}

export interface FindingPhoto {
  id: string;
  findingId: string;
  storageUri: string;
  sha256: string;
  capturedAt: Date;
  capturedBy: string;
}

export function isInspectionComplete(
  inspection: Inspection,
  requiredItems: ChecklistItem[]
): boolean {
  const answered = new Set(inspection.answers.map((answer) => answer.checklistItemId));
  return requiredItems.every((item) => answered.has(item.id));
}

export function deriveInspectionResult(
  answers: InspectionAnswer[]
): InspectionResult {
  if (answers.length === 0) return "INCONCLUSIVA";
  if (answers.some((answer) => answer.result === "NAO_CONFORME")) {
    return "NAO_CONFORME";
  }
  return "CONFORME";
}
