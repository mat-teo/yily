class ReasonCounts {
  final int sent;
  final int received;
  final int total;

  ReasonCounts({
    required this.sent,
    required this.received,
    required this.total,
  });

  factory ReasonCounts.fromJson(Map<String, dynamic> json) {
    return ReasonCounts(
      sent: json['sent'] as int,
      received: json['received'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'sent': sent,
        'received': received,
        'total': total,
      };
}