class DisputeUtil {
  static String changeTheme(String selectTheme) {
    switch (selectTheme) {
      case "chat.disputeTheme.noResponse":
        return "chat.disputeTheme.noResponse";
      case "chat.disputeTheme.badlyDone":
        return "chat.disputeTheme.badlyDone";
      case "chat.disputeTheme.additionalRequirements":
        return "chat.disputeTheme.additionalRequirements";
      case "chat.disputeTheme.inconsistencies":
        return "chat.disputeTheme.inconsistencies";
      case "chat.disputeTheme.notConfirmed":
        return "chat.disputeTheme.notConfirmed";
      case "chat.disputeTheme.anotherReason":
        return "chat.disputeTheme.anotherReason";
      default:
        return "chat.disputeTheme.anotherReason";
    }
  }

  static String getThemeValue(String theme) {
    switch (theme) {
      case "chat.disputeTheme.noResponse":
        return "NoAnswer";
      case "chat.disputeTheme.badlyDone":
        return "PoorlyDoneJob";
      case "chat.disputeTheme.additionalRequirements":
        return "AdditionalRequirement";
      case "chat.disputeTheme.inconsistencies":
        return "RequirementDoesNotMatch";
      case "chat.disputeTheme.notConfirmed":
        return "NoConfirmationOfComplete";
      case "chat.disputeTheme.anotherReason":
        return "AnotherReason";
      default:
        throw FormatException('Unknown theme');
    }
  }
}

class DisputeConstants {
  static const List<String> disputeCategoriesList = [
    "chat.disputeTheme.noResponse",
    "chat.disputeTheme.badlyDone",
    "chat.disputeTheme.additionalRequirements",
    "chat.disputeTheme.inconsistencies",
    "chat.disputeTheme.notConfirmed",
    "chat.disputeTheme.anotherReason"
  ];
}
