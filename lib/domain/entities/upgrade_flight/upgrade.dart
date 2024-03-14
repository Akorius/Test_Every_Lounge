class CreateUpgradeOrderObject {
  CreateUpgradeOrderObject({
    required this.pnr,
    required this.lastName,
    required this.airport,
    required this.upgrades,
  });

  final String pnr;
  final String lastName;
  final String airport;
  final List<CreateUpgradeOrderObjectPosition> upgrades;

  Map<String, dynamic> toJson() {
    return {
      'pnr': pnr,
      'last_name': lastName,
      'airport': airport,
      'upgrades': upgrades.map((e) => e.toJson()).toList(),
    };
  }
}

class CreateUpgradeOrderObjectPosition {
  CreateUpgradeOrderObjectPosition({
    required this.segmentNumber,
    required this.refNumber,
    required this.rficCode,
    required this.rfiscCode,
    required this.amount,
  });

  final int segmentNumber;
  final String refNumber;
  final String rficCode;
  final String rfiscCode;
  final String amount;

  Map<String, dynamic> toJson() {
    return {
      'segment_number': segmentNumber,
      'ref_number': refNumber,
      'rfic_code': rficCode,
      'rfisc_code': rfiscCode,
      'amount': amount,
    };
  }
}
