import 'package:easy_localization/easy_localization.dart';

class SkillUtils {
  static List<String> parser(List<String> skills) {
    List<String> result = [];
    for (String skill in skills ){
      final _spec = skill.split(".").first;
      final _skill = skill.split('.').last;
      result.add("filters.items.$_spec.sub.$_skill".tr());
    }
    return result;
  }
}