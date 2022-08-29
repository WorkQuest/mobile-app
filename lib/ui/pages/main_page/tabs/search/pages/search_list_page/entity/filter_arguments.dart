import 'package:app/enums.dart';
import 'package:decimal/decimal.dart';

class FilterArguments {
  final String sort;
  final String fromPrice;
  final String toPrice;
  final List<String> employments;
  final List<String> workplaces;
  final List<String> payPeriod;
  final List<int> employeeRatings;
  final List<String> selectedSkill;
  final List<int> priorities;

  const FilterArguments({
    required this.sort,
    required this.fromPrice,
    required this.toPrice,
    required this.employments,
    required this.workplaces,
    required this.payPeriod,
    required this.employeeRatings,
    required this.selectedSkill,
    required this.priorities,
  });

  factory FilterArguments.empty() => const FilterArguments(
        sort: "sort[createdAt]=desc",
        fromPrice: '',
        toPrice: '',
        employments: [],
        workplaces: [],
        payPeriod: [],
        employeeRatings: [],
        selectedSkill: [],
        priorities: [],
      );

  String getFilterPrice(UserRole role) {
    String result = '';
    if (role == UserRole.Worker) {
      if (fromPrice.isNotEmpty || toPrice.isNotEmpty) {
        final _fromPrice =
            Decimal.parse(fromPrice.isNotEmpty ? fromPrice : '0') *
                Decimal.fromInt(10).pow(18);
        result += '&priceBetween[from]=${_fromPrice.toBigInt()}';
        final _toPrice =
            Decimal.parse(toPrice.isNotEmpty ? toPrice : '999999999999999') *
                Decimal.fromInt(10).pow(18);
        result += '&priceBetween[to]=${_toPrice.toBigInt()}';
      }
    } else {
      if (fromPrice.isNotEmpty || toPrice.isNotEmpty) {
        result +=
            '&betweenCostPerHour[from]=${fromPrice.isNotEmpty ? fromPrice : '0'}';
        result +=
            '&betweenCostPerHour[to]=${toPrice.isNotEmpty ? toPrice : '999999999999999'}';
      }
    }
    return result;
  }
}
