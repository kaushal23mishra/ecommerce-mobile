class OldCarPayment {
  final bool? isGiven;
  final int? amountPending;
  final String? agentName;
  final String? agentNumber;
  final String? expectedDateOfPayment;
  final String? remarks;

  const OldCarPayment({
    this.isGiven,
    this.amountPending,
    this.agentName,
    this.agentNumber,
    this.expectedDateOfPayment,
    this.remarks,
  });

  OldCarPayment copyWith({
    bool? isGiven,
    int? amountPending,
    String? agentName,
    String? agentNumber,
    String? expectedDateOfPayment,
    String? remarks,
  }) {
    return OldCarPayment(
      isGiven: isGiven ?? this.isGiven,
      amountPending: amountPending ?? this.amountPending,
      agentName: agentName ?? this.agentName,
      agentNumber: agentNumber ?? this.agentNumber,
      expectedDateOfPayment: expectedDateOfPayment ?? this.expectedDateOfPayment,
      remarks: remarks ?? this.remarks,
    );
  }
}
