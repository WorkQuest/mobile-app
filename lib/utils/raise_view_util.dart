class RaiseViewConstants {
  static const tariffGoldPlus = 0;
  static const tariffGold = 1;
  static const tariffSilver = 2;
  static const tariffBronze = 3;

  static const statusActive = 0;
  static const statusNoActive = 1;

  static const List<String> forDay = [r"20$", r"12$", r"9$", r"7$"];
  static const List<String> forWeek = [r"35$", r"28$", r"22$", r"18$"];
  static const List<String> forMonth = [r"50$", r"35$", r"29$", r"21$"];
}

class RaiseViewUtils {

  static String getTypeTitle(int value) {
    if (value == RaiseViewConstants.tariffGoldPlus) {
      return 'Gold plus package';
    } else if (value == RaiseViewConstants.tariffGold) {
      return 'Gold package';
    } else if (value == RaiseViewConstants.tariffSilver) {
      return 'Silver package';
    } else if (value == RaiseViewConstants.tariffBronze) {
      return 'Bronze package';
    }
    return 'Unknown type';
  }

  static String getAmount({
    required bool isQuest,
    required int tariff,
    required int period,
  }) {
    if (isQuest) {
      switch (period) {
        case 1:
          switch (tariff) {
            case 0:
              return '20';
            case 1:
              return '12';
            case 2:
              return '9';
            case 3:
              return '7';
          }
          break;
        case 5:
          switch (tariff) {
            case 0:
              return '35';
            case 1:
              return '28';
            case 2:
              return '22';
            case 3:
              return '18';
          }
          break;
        case 7:
          switch (tariff) {
            case 0:
              return '50';
            case 1:
              return '35';
            case 2:
              return '29';
            case 4:
              return '21';
          }
          break;
      }
    } else {
      switch (period) {
        case 1:
          switch (tariff) {
            case 0:
              return '20';
            case 1:
              return '12';
            case 2:
              return '9';
            case 3:
              return '7';
          }
          break;
        case 7:
          switch (tariff) {
            case 0:
              return '35';
            case 1:
              return '28';
            case 2:
              return '22';
            case 3:
              return '18';
          }
          break;
        case 30:
          switch (tariff) {
            case 0:
              return '50';
            case 1:
              return '35';
            case 2:
              return '29';
            case 3:
              return '21';
          }
          break;
      }
    }
    throw FormatException('No unknown amount');
  }

  static int getPeriod({
    required int periodGroupValue,
    bool isQuest = false,
  }) {
    if (isQuest) {
      switch (periodGroupValue) {
        case 1:
          return 1;
        case 2:
          return 5;
        case 3:
          return 7;
      }
    } else {
      switch (periodGroupValue) {
        case 1:
          return 1;
        case 2:
          return 7;
        case 3:
          return 30;
      }
    }
    throw FormatException('No unknown period');
  }
}
