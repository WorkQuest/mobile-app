import 'package:app/ui/widgets/skill_specialization_selection/store/skill_specialization_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';

class SkillSpecializationSelection extends StatefulWidget {
  final SkillSpecializationController? controller;
  final List<String>? data;

  SkillSpecializationSelection({this.controller, this.data});

  @override
  _SkillSpecializationSelectionState createState() =>
      _SkillSpecializationSelectionState();
}

class _SkillSpecializationSelectionState
    extends State<SkillSpecializationSelection>
    with AutomaticKeepAliveClientMixin {
  final store = SkillSpecializationStore();
  final maxLength = 5;

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
    super.build(context);
    return Observer(
      builder: (_) => Column(
        children: [
          for (int i = 0; i < store.numberOfSpices; i++) getSelector(i),
          if (store.selectedSkills.length != 0)
            if (store.numberOfSpices != 0)
              OutlinedButton(
                onPressed: store.deleteSpices,
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
          if (store.numberOfSpices < 3)
            OutlinedButton(
              onPressed: store.addSpices,
              child: Text(
                "settings.addSpec".tr(),
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
        ],
      ),
    );
  }

  Widget getSelector(int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text("settings.specialization".tr() + " ${count + 1}"),
        const SizedBox(height: 5),
        getSpecializationSelector(count),
        const SizedBox(height: 20),
        if (store.selectedSpices[count] != null) getSkillSelector(count),
      ],
    );
  }

  Widget getSkillSelector(int count) {
    final title = store.selectedSpices[count]!.header;
    final list = store.selectedSpices[count]!.list
        .where((element) => !store.selectedSkills[count]!.contains(element))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "skills.title".tr(),
        ),
        const SizedBox(height: 5),
        getSelectorButton<String>(
          placeholder: "mining.choose".tr(),
          data: list,
          builder: (item) => Center(
            child: new Text(
              "filters.items.$title.sub.$item".tr(),
            ),
          ),
          onSelect: (store.selectedSkills[count]?.length ?? 0) == maxLength
              ? (item) {
                  store.countSkills = false;
                }
              : (item) {
                  if ((store.selectedSkills[count]?.length ?? 0) < maxLength) {
                    store.selectedSkills[count]!.add(item);
                    store.countSkills = true;
                  }
                },
        ),
        if (store.countSkills == false &&
            (store.selectedSkills[count]?.length ?? 0) == maxLength)
          Text(
            "ui.buttons.errors.manySkill".tr(),
            style: TextStyle(
              color: Color(0xFFf36262),
              fontSize: 16,
            ),
          ),
        const SizedBox(height: 10),
        Observer(
          builder: (_) => Wrap(
            children: store.selectedSkills[count]!
                .map((str) => skillBody("filters.items.$title.sub.$str", () {
                      store.selectedSkills[count]!.remove(str);
                      setState(() {});
                    }))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget getSpecializationSelector(int count) {
    final list = store.allSpices
        .where((element) => !store.selectedSpices.values.contains(element))
        .toList();
    return getSelectorButton<Specialization>(
        placeholder: store.selectedSpices[count]?.header != null
            ? "filters.items.${store.selectedSpices[count]?.header}.title".tr()
            : "mining.choose".tr(),
        data: list,
        builder: (item) => Center(
              child: new Text(
                "filters.items.${item.header}.title".tr(),
              ),
            ),
        onSelect: (item) {
          store.selectedSpices[count] = item;
          store.selectedSkills[count] = [];
        });
  }

  Widget skillBody(String title, void Function() onRemove) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ActionChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 100,
              ),
              child: Text(
                title.tr(),
                style: const TextStyle(
                  color: const Color(0xFF0083C7),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
            const Icon(
              Icons.close,
              size: 20,
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(0, 131, 199, 0.1),
        onPressed: onRemove,
      ),
    );
  }

  Widget getSelectorButton<T>({
    required String placeholder,
    required List<T> data,
    required Widget Function(T) builder,
    required void Function(T) onSelect,
  }) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F8FA),
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () => modalBottomSheet(
            DraggableScrollableSheet(
              initialChildSize: 0.9,
              builder: (context, scrollController) => ListView.separated(
                addAutomaticKeepAlives: true,
                padding: const EdgeInsets.symmetric(
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
            isScrollControlled: data.length > 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                placeholder,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              size: 30,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  modalBottomSheet(Widget child, {bool isScrollControlled = false}) =>
      showModalBottomSheet(
          isScrollControlled: isScrollControlled,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          context: context,
          builder: (context) {
            return child;
          });

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class SkillSpecializationController {
  SkillSpecializationStore? store;
  List<String>? initialValue;

  SkillSpecializationController({this.initialValue});

  setStore(SkillSpecializationStore store, List<String>? initialValue) {
    this.store = store;
    if (initialValue != null) {
      store.numberOfSpices = 0;
      initialValue.forEach((item) {

      //   store.numberOfFiled.add(KnowledgeWork(
      //     dateFrom: item["from"] ?? "",
      //     dateTo: item["to"] ?? "",
      //     place: item["place"] ?? "",
      //   ));
      });
    }
  }

  List<String> getSkillAndSpecialization() {
    List<String> genMap = [];
    if (store != null) {
      for (final index in store!.selectedSpices.keys) {
        for (int i = 0; i < (store!.selectedSkills[index]?.length ?? 0); i++)
          genMap.add("${int.parse(store!.selectedSkills[index]![i]) ~/ 100}" +
              ".${int.parse(store!.selectedSkills[index]![i])}");
      }
    }
    return genMap;
  }
}
