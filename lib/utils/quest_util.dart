import 'package:easy_localization/easy_localization.dart';

class QuestConstants {
  static final List<String> priorityList = [
    "quests.priority.low".tr(),
    "quests.priority.normal".tr(),
    "quests.priority.urgent".tr(),
  ];

  static final List<String> employmentList = [
    "Full time",
    "Part time",
    "Fixed term",
    "Remote work",
    "Employment contract",
  ];

  static final List<String> distantWorkList = [
    "Distant work",
    "Work in the office",
    "Both variant",
  ];

  static final List<String> payPeriodList = [
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
}

class QuestUtils {
  static String getEmployment(String employment) {
    switch (employment) {
      case "FullTime":
        return "Full time";
      case "PartTime":
        return "Part time";
      case "FixedTerm":
        return "Fixed term";
      case "RemoteWork":
        return "Remote Work";
      case "EmploymentContract":
        return "Employment Contract";
      default:
        throw FormatException('Unknown Employment');
    }
  }

  static String getPriorityFromValue(int index) {
    if (index == 1) {
      return "Fixed delivery";
    } else if (index == 2) {
      return "Short term 1 week";
    } else if (index == 3) {
      return "Urgent 24-72h";
    } else {
      throw FormatException('Unknown Priority');
    }
  }

  static String getPayPeriodValue(String payPeriod) {
    switch (payPeriod) {
      case "Hourly":
        return "Hourly";
      case "Daily":
        return "Daily";
      case "Weekly":
        return "Weekly";
      case "BiWeekly":
        return "BiWeekly";
      case "Semi monthly":
        return "SemiMonthly";
      case "Monthly":
        return "Monthly";
      case "Quarterly":
        return "Quarterly";
      case "Semi annually":
        return "SemiAnnually";
      case "Annually":
        return "Annually";
      case "Fixed period":
        return "FixedPeriod";
      case "By agreement":
        return "ByAgreement";
      default:
        throw FormatException('Unknown Pay Period');
    }
  }

  static String getWorkplace(String workplaceValue) {
    switch (workplaceValue) {
      case "Remote":
        return "Distant work";
      case "InOffice":
        return "Work in the office";
      case "Hybrid":
        return "Both variant";
      default:
        throw FormatException('Unknown Workplace');
    }
  }

  static String getWorkplaceValue(String workplace) {
    switch (workplace) {
      case "Distant work":
        return "Remote";
      case "Work in the office":
        return "InOffice";
      case "Both variant":
        return "Hybrid";
      default:
        throw FormatException('Unknown Workplace Value');
    }
  }

  static int getPriorityToValue(String priority) {
    switch (priority) {
      case "Fixed delivery":
        return 1;
      case "Short term 1 week":
        return 2;
      case "Urgent 24-72h":
        return 3;
      default:
        throw FormatException('Unknown Priority Value');
    }
  }

  static String getEmploymentValue(String employment) {
    switch (employment) {
      case "Full time":
        return "FullTime";
      case "Part time":
        return "PartTime";
      case "Fixed term":
        return "FixedTerm";
      case "Remote work":
        return "RemoteWork";
      case "Employment contract":
        return "EmploymentContract";
      default:
        throw FormatException('Unknown Employment Value');
    }
  }
}
