class GroupChat {
  GroupChat({
    required this.name,
    required this.ownerMemberId,
  });

  String name;
  String ownerMemberId;

  factory GroupChat.fromJson(Map<String, dynamic> json) => GroupChat(
        name: json["name"],
        ownerMemberId: json["ownerMemberId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "ownerMemberId": ownerMemberId,
      };
}
