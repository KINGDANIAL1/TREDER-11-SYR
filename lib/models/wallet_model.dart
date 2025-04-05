class WalletModel {
  final String userId;
  final Map<String, double> balances;
  final Map<String, String> depositAddresses;

  WalletModel({
    required this.userId,
    required this.balances,
    required this.depositAddresses,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      userId: json['userId'],
      balances: Map<String, double>.from(json['balances']),
      depositAddresses: Map<String, String>.from(json['depositAddresses']),
    );
  }
}