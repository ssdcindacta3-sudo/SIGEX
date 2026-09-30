export type UnitType = "CINDACTA_III" | "DTCEA";

export interface TransferEndpoint {
  unitType: UnitType;
}

export function canTransfer(
  origin: TransferEndpoint,
  destination: TransferEndpoint
): boolean {
  if (origin.unitType === "CINDACTA_III") return true;
  return destination.unitType === "CINDACTA_III";
}
