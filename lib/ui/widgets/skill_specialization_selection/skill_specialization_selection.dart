import 'package:app/ui/widgets/skill_specialization_selection/store/skill_specialization_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SkillSpecializationSelection extends StatefulWidget {
  @override
  _SkillSpecializationSelectionState createState() =>
      _SkillSpecializationSelectionState();
}

class _SkillSpecializationSelectionState
    extends State<SkillSpecializationSelection> {
  final store = SkillSpecializationStore();
  int countSelectors = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < countSelectors; i++) getSelector(i),
        if (countSelectors != 0)
          OutlinedButton(
            onPressed: () {
              if (store.selectSkills[countSelectors - 1] != null) {
                store.selectSkills.remove(countSelectors - 1);
              }
              store.selectSpecializations.remove(countSelectors - 1);
              countSelectors -= 1;
              setState(() {});
            },
            child: Text(
              "Delete",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFDF3333),
              ),
            ),
            style: OutlinedButton.styleFrom(
              fixedSize: Size.fromWidth(double.maxFinite),
              side: BorderSide(
                width: 1.0,
                color: Color.fromRGBO(223, 51, 51, 0.1),
              ),
            ),
          ),
        if (countSelectors < 3)
          OutlinedButton(
            onPressed: () {
              setState(() {
                countSelectors += 1;
              });
            },
            child: Text(
              "Add specialization",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF0083C7),
              ),
            ),
            style: OutlinedButton.styleFrom(
              fixedSize: Size.fromWidth(double.maxFinite),
              side: BorderSide(
                width: 1.0,
                color: Color.fromRGBO(0, 131, 199, 0.1),
              ),
            ),
          ),
      ],
    );
  }

  Widget getSelector(int count) {
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Specialization ${count + 1}"),
          const SizedBox(height: 5),
          getSpecializationSelector(count),
          const SizedBox(height: 20),
          if (store.selectSpecializations[count] != null)
            getSkillSelector(count),
        ],
      ),
    );
  }

  Widget getSkillSelector(int count) {
    final list = store.selectSpecializations[count]!.list
        .where((element) => !store.selectSkills[count]!.contains(element))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Skill"),
        const SizedBox(height: 5),
        getSelectorButton<String>(
            plaseholder: "Choose",
            data: list,
            builder: (item) => Center(
                    child: new Text(
                  item,
                  textAlign: TextAlign.center,
                )),
            onSelect: (item) {
              store.selectSkills[count]!.add(item);
            }),
        const SizedBox(height: 10),
        Wrap(
          children: store.selectSkills[count]!
              .map((str) => skillBody(
                    str,
                    () {
                      store.selectSkills[count]!.remove(str);
                      setState(() {});
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget skillBody(String title, void Function() onRemove) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ActionChip(
          label: Row(mainAxisSize: MainAxisSize.min, children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 100),
              child: Text(
                title,
                style: TextStyle(color: const Color(0xFF0083C7)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
            const Icon(
              Icons.close,
              size: 20,
            ),
          ]),
          backgroundColor: const Color.fromRGBO(0, 131, 199, 0.1),
          onPressed: onRemove),
    );

    // return Container(
    //   margin: const EdgeInsets.only(right: 10, bottom: 10),
    //   padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(44),
    //     color: const Color.fromRGBO(0, 131, 199, 0.1),
    //   ),
    //   child: Row(mainAxisSize: MainAxisSize.min, children: [
    //     Text(
    //       title,
    //       style: TextStyle(
    //         color: const Color(0xFF0083C7),
    //       ),
    //     ),
    //     GestureDetector(
    //       onTap: onRemove,
    //       child: Padding(
    //         padding: const EdgeInsets.only(left: 4, right: 1),
    //         child: const Icon(
    //           Icons.close,
    //           size: 20,
    //         ),
    //       ),
    //     ),
    //   ]),
    // );
  }

  Widget getSpecializationSelector(int count) {
    return getSelectorButton<FilterItem>(
        plaseholder: store.selectSpecializations[count]?.header ?? "Choose",
        data: store.specialization,
        builder: (item) => Center(
                child: new Text(
              item.header,
              textAlign: TextAlign.center,
            )),
        onSelect: (item) {
          store.selectSpecializations[count] = item;
          store.selectSkills[count] = [];
        });
  }

  Widget getSelectorButton<T>({
    required String plaseholder,
    required List<T> data,
    required Widget Function(T) builder,
    required void Function(T) onSelect,
  }) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xFFF7F8FA),
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () => modalBottomSheet(
          DraggableScrollableSheet(
            initialChildSize: 1.0,
            expand: false,
            builder: (context, scrollController) => ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black12,
                endIndent: 50.0,
                indent: 50.0,
              ),
              controller: scrollController,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) => SizedBox(
                height: 40.0,
                width: double.maxFinite,
                child: InkWell(
                  onTap: () {
                    onSelect(data[index]);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: builder(data[index]),
                ),
              ),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                plaseholder,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 30,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  modalBottomSheet(Widget child) => showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(
            20.0,
          ),
        ),
      ),
      context: context,
      builder: (context) {
        return child;
      });
}
