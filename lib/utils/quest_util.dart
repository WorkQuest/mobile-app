import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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

  static const int questClosed = -3;
  static const int questDispute = -2;
  static const int questRejected = -1;
  static const int questBlocked = -1;
  static const int questPending = 0;
  static const int questCreated = 1;
  static const int questWaitWorkerOnAssign = 2;
  static const int questWaitWorker = 3;
  static const int questWaitEmployerConfirm = 4;
  static const int questDone = 5;

  static const int questResponseRejected = -1;
  static const int questResponseOpen = 0;
  static const int questResponseAccepted = 1;
  static const int questResponseClosed = 2;

  static const int questResponseTypeResponded = 0;
  static const int questResponseTypeInvited = 1;
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
        return "Remote work";
      case "EmploymentContract":
        return "Employment contract";
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

  static String getPayPeriod(String payPeriod) {
    switch (payPeriod) {
      case "Hourly":
        return "Hourly";
      case "Daily":
        return "Daily";
      case "Weekly":
        return "Weekly";
      case "BiWeekly":
        return "BiWeekly";
      case "SemiMonthly":
        return "Semi monthly";
      case "Monthly":
        return "Monthly";
      case "Quarterly":
        return "Quarterly";
      case "SemiAnnually":
        return "Semi annually";
      case "Annually":
        return "Annually";
      case "FixedPeriod":
        return "Fixed period";
      case "ByAgreement":
        return "By agreement";
      default:
        throw FormatException('Unknown Pay Period');
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
        throw FormatException('Unknown Pay Period Value');
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

  static String getPrice(String price) {
    try {
      final _price =
          (Decimal.parse(price) / Decimal.fromInt(10).pow(18)).toDouble();
      return _price
          .toStringAsFixed(_price.truncateToDouble() == _price ? 0 : 4);
    } catch (e) {
      return '0.00';
    }
  }

  static Color getColorBorder(int? status, int? type) {
    if (status == 0) {
      switch (type) {
        case 0:
          return AppColor.gold;
        case 1:
          return AppColor.gold;
        case 2:
          return AppColor.silver;
        case 3:
          return AppColor.bronze;
        default:
          return Colors.transparent;
      }
    } else {
      return Colors.transparent;
    }
  }

  static bool isResponded(BaseQuestResponse questItem) =>
      (questItem.responded!.workerId ==
                  GetIt.I.get<ProfileMeStore>().userData?.id &&
              (questItem.status == QuestConstants.questCreated ||
                  questItem.status == QuestConstants.questWaitWorkerOnAssign) ||
          questItem.responded != null &&
              questItem.responded?.type ==
                  QuestConstants.questResponseTypeResponded) &&
      GetIt.I.get<ProfileMeStore>().userData?.role == UserRole.Worker;

  static bool isLocation(BaseQuestResponse questItem) =>
      questItem.userId != GetIt.I.get<ProfileMeStore>().userData?.id &&
      questItem.status != QuestConstants.questWaitEmployerConfirm &&
      questItem.status != QuestConstants.questDone;

  static bool isInvited(BaseQuestResponse questItem) =>
      questItem.responded != null &&
      questItem.responded?.type == QuestConstants.questResponseTypeInvited;

  static bool isRaised(BaseQuestResponse questItem) =>
      questItem.raiseView != null &&
      questItem.raiseView!.status != null &&
      questItem.raiseView!.status == 0;
}
