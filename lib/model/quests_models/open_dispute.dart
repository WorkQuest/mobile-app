class OpenDispute {
  OpenDispute({
    required this.id,
    required this.openDisputeUserId,
    required this.opponentUserId,
    required this.assignedAdminId,
    required this.status,
  });

  String id;
  String? openDisputeUserId;
  String? opponentUserId;
  String? assignedAdminId;
  int status;

  factory OpenDispute.fromJson(Map<String, dynamic> json) => OpenDispute(
        id: json["id"],
        openDisputeUserId: json["openDisputeUserId"],
        opponentUserId: json["opponentUserId"],
        assignedAdminId: json["assignedAdminId"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "openDisputeUserId": openDisputeUserId,
        "opponentUserId": opponentUserId,
        "assignedAdminId": assignedAdminId,
        "status": status,
      };
}
