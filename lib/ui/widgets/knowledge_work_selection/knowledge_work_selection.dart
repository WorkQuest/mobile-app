import 'package:app/ui/widgets/knowledge_work_selection/store/knowledge_work_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';

class KnowledgeWorkSelection extends StatefulWidget {
  final String title;
  final String hintText;
  final KnowledgeWorkSelectionController? controller;
  final List<Map<String, String>>? data;

  KnowledgeWorkSelection({
    required this.title,
    required this.hintText,
    required this.controller,
    required this.data,
  });

  @override
  _KnowledgeWorkSelection createState() => _KnowledgeWorkSelection();
}

class _KnowledgeWorkSelection extends State<KnowledgeWorkSelection> {
  final store = KnowledgeWorkStore();

  @override
  void initState() {
    if (widget.controller != null)
      widget.controller!.setStore(
        this.store,
        this.widget.data,
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF1D2127),
              ),
            ),
          ),
          ...store.numberOfFiled
              .map((element) => addKnowledgeField(element, widget.hintText))
              .toList(),
          if (store.numberOfFiled.length < 3)
            OutlinedButton(
              onPressed: () {
                if (widget
                    .controller!.store!.numberOfFiled.isEmpty)
                  widget.controller!.store!.addField(KnowledgeWork());
                if (widget
                    .controller!.store!.numberOfFiled.last.fieldIsNotEmpty) {
                  widget.controller!.store!.addField(KnowledgeWork());
                }
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
                      initialValue:
                          widget.controller!.store!.numberOfFiled.last.dateFrom,
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
                      initialValue:
                          widget.controller!.store!.numberOfFiled.last.dateTo,
                      date: "settings.education.to".tr(),
                      onChanged: (text) {
                        kng.dateTo = text;
                      },
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
                    initialValue:
                        widget.controller!.store!.numberOfFiled.last.place,
                    onChanged: (text) => kng.place = text,
                    decoration: InputDecoration(
                      hintText: hintText,
                      fillColor: Colors.white,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(150),
                    ],
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

class KnowledgeWorkSelectionController {
  KnowledgeWorkStore? store;
  List<Map<String, String>>? initialValue;

  KnowledgeWorkSelectionController({this.initialValue});

  void setStore(
      KnowledgeWorkStore store, List<Map<String, String>>? initialValue) {
    this.store = store;
    if (initialValue != null && initialValue != []) {
      store.numberOfFiled.clear();
      initialValue.forEach((item) {
        store.numberOfFiled.add(KnowledgeWork(
          dateFrom: item["from"] ?? "",
          dateTo: item["to"] ?? "",
          place: item["place"] ?? "",
        ));
      });
    }
  }

  // List<KnowledgeWork> getAllKnowledge() {
  //   return store?.numberOfFiled ?? [];
  // }

  List<Map<String, String>> getListMap() {
    List<Map<String, String>> listMap = [];
    (store?.numberOfFiled ?? []).forEach((element) {
      Map<String, String> item = {};
      item["from"] = element.dateFrom;
      item["to"] = element.dateTo;
      item["place"] = element.place;
      listMap.add(item);
    });
    return listMap;
  }
}
