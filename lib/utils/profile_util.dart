class ProfileConstants {
  static const unconfirmedStatus = 0;
  static const confirmedStatus = 1;
  static const needSetRoleStatus = 2;

  static const List<String> payPeriodLists = [
    "quests.payPeriod.hourly",
    "quests.payPeriod.daily",
    "quests.payPeriod.weekly",
    "quests.payPeriod.biWeekly",
    "quests.payPeriod.semiMonthly",
    "quests.payPeriod.monthly",
    "quests.payPeriod.quarterly",
    "quests.payPeriod.semiAnnually",
    "quests.payPeriod.annually",
    "quests.payPeriod.fixedPeriod",
    "quests.payPeriod.byAgreement",
  ];

  static const List<String> priorityList = [
    "quests.priority.all",
    "quests.priority.urgent",
    "quests.priority.normal",
    "quests.priority.low",
  ];

  static const List<String> distantWorkList = [
    "Remote work",
    "In-office",
    "Hybrid workplace",
  ];
}

class ProfileUtils {
  static String payPeriodToValue(String? payPeriod) {
    switch (payPeriod) {
      case "Hourly":
        return "quests.payPeriod.hourly";

      case "Daily":
        return "quests.payPeriod.daily";

      case "Weekly":
        return "quests.payPeriod.weekly";

      case "BiWeekly":
        return "quests.payPeriod.biWeekly";

      case "SemiMonthly":
        return "quests.payPeriod.semiMonthly";

      case "Monthly":
        return "quests.payPeriod.monthly";

      case "Quarterly":
        return "quests.payPeriod.quarterly";

      case "SemiAnnually":
        return "quests.payPeriod.semiAnnually";

      case "Annually":
        return "quests.payPeriod.fixedPeriod";

      case "FixedPeriod":
        return "quests.payPeriod.fixedPeriod";

      case "ByAgreement":
        return "quests.payPeriod.byAgreement";
      default:
        throw FormatException('Unknown pay period');
    }
  }

  static String valueToPayPeriod(String payPeriod) {
    switch (payPeriod) {
      case "quests.payPeriod.hourly":
        return "Hourly";
      case "quests.payPeriod.daily":
        return "Daily";
      case "quests.payPeriod.weekly":
        return "Weekly";
      case "quests.payPeriod.biWeekly":
        return "BiWeekly";
      case "quests.payPeriod.semiMonthly":
        return "SemiMonthly";
      case "quests.payPeriod.monthly":
        return "Monthly";
      case "quests.payPeriod.quarterly":
        return "Quarterly";
      case "quests.payPeriod.semiAnnually":
        return "SemiAnnually";
      case "quests.payPeriod.fixedPeriod":
        return "Annually";
      case "quests.payPeriod.fixedPeriod":
        return "FixedPeriod";
      case "quests.payPeriod.byAgreement":
        return "ByAgreement";
    }
    return "";
  }

  static String priorityToValue(int priority) {
    switch (priority) {
      case 0:
        return "quests.priority.all";
      case 1:
        return "quests.priority.urgent";
      case 2:
        return "quests.priority.normal";
      case 3:
        return "quests.priority.low";
    }
    return '';
  }

  static int valueToPriority(String priorityValue) {
    switch (priorityValue) {
      case "quests.priority.all":
        return  0;
      case "quests.priority.urgent":
        return  1;
      case "quests.priority.normal":
        return  2;
      case "quests.priority.low":
        return  3;
    }
    return 0;
  }

  static String workplaceToValue(String? workplace) {
    switch (workplace) {
      case "Remote":
        return ProfileConstants.distantWorkList[0];
      case "InOffice":
        return ProfileConstants.distantWorkList[1];
      case "Hybrid":
        return ProfileConstants.distantWorkList[2];
    }
    return '';
  }

  static String valueToWorkplace(String? distantWork) {
    switch (distantWork) {
      case "Remote work":
        return  "Remote";
      case "In-office":
        return  "InOffice";
      case "Hybrid workplace":
        return  "Hybrid";
      default:
        return distantWork ?? "Hybrid";
    }
  }
}
