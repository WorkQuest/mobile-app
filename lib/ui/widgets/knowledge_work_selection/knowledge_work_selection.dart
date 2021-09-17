import 'package:app/ui/widgets/knowledge_work_selection/store/knowledge_work_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';

class KnowledgeWorkSelection extends StatefulWidget {
  final String title;
  final String hintText;

  const KnowledgeWorkSelection({required this.title, required this.hintText});

  @override
  _KnowledgeWorkSelection createState() =>
      _KnowledgeWorkSelection(title, hintText);
}

class _KnowledgeWorkSelection extends State<KnowledgeWorkSelection> {
  final store = KnowledgeWorkStore();
  final String title;
  final String hintText;

  _KnowledgeWorkSelection(this.title, this.hintText);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF1D2127),
              ),
            ),
          ),
          ...store.numberOfFiled
              .map((element) => addKnowledgeField(element, hintText))
              .toList(),
          if (store.numberOfFiled.length < 5)
            OutlinedButton(
              onPressed: () {
                if (store.numberOfFiled.last.fieldIsNotEmpty)
                  store.addField(KnowledgeWork());
              },
              child: Text(
                "settings.add".tr(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF0083C7),
                ),
              ),
              style: OutlinedButton.styleFrom(
                fixedSize: const Size.fromWidth(double.maxFinite),
                side: const BorderSide(
                  width: 1.0,
                  color: Color.fromRGBO(0, 131, 199, 0.1),
                ),
              ),
            ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget addKnowledgeField(KnowledgeWork kng, String hintText) {
    return Column(
      key: ValueKey(kng.id),
      children: <Widget>[
        const SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFE9EDF2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    dateField(
                      initialValue: kng.dateFrom,
                      date: "settings.education.from".tr(),
                      onChanged: (text) => kng.dateFrom = text,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "-",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1D2127),
                        ),
                      ),
                    ),
                    dateField(
                      initialValue: kng.dateTo,
                      date: "settings.education.to".tr(),
                      onChanged: (text) => kng.dateTo = text,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFE9EDF2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextFormField(
                    initialValue: kng.institution,
                    onChanged: (text) => kng.institution = text,
                    decoration: InputDecoration(
                      hintText: hintText,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (store.numberOfFiled.length > 1)
                  OutlinedButton(
                    onPressed: () {
                      store.deleteField(kng);
                    },
                    child: Text(
                      "settings.delete".tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFDF3333),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size.fromWidth(double.maxFinite),
                      side: const BorderSide(
                        width: 1.0,
                        color: Color.fromRGBO(223, 51, 51, 0.1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget dateField({
    required String date,
    required String initialValue,
    required void Function(String)? onChanged,
  }) {
    return Container(
      height: 40,
      width: 147,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFE9EDF2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: date,
          fillColor: Colors.white,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(4),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}
