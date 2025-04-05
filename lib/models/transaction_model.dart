
class TransactionModel {
  final String id;
  final String userId;
  final String type;
  final String currency;
  final double amount;
  final String? address;
  final String status;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.currency,
    required this.amount,
    this.address,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'],
      userId: json['userId'],
      type: json['type'],
      currency: json['currency'],
      amount: json['amount'].toDouble(),
      address: json['address'],
      status: json['status'],
    );
  }
}