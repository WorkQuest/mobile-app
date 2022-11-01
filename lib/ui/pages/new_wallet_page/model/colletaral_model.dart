class CollateralTransactionModel {
  final String token;
  final String amount;
  final String ratio;
  final String locked;
  final String icon;
  CollateralTransactionModel(
      {required this.icon,
      required this.token,
      required this.amount,
      required this.ratio,
      required this.locked});
}
