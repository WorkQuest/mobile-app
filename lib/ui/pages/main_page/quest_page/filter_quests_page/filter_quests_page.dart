import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/quest_page/filter_quests_page/store/filter_quests_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';
import "package:provider/provider.dart";

class FilterQuestsPage extends StatefulWidget {
  const FilterQuestsPage({Key? key}) : super(key: key);
  static const String routeName = '/filterQuestPage';

  @override
  State<FilterQuestsPage> createState() => _FilterQuestsPageState();
}

class _FilterQuestsPageState extends State<FilterQuestsPage>
    with AutomaticKeepAliveClientMixin {
  FilterQuestsStore? storeFilter;
  ProfileMeStore? profile;
  late final QuestsStore storeQuest;

  @override
  void initState() {
    storeFilter = context.read<FilterQuestsStore>();
    profile = context.read<ProfileMeStore>();
    storeQuest = context.read<QuestsStore>();
    if (storeFilter != null) {
      storeFilter!.getFilters();
      // storeFilter!.readFilters();
      storeFilter!.selectEmployment = storeFilter!.employment;
      storeFilter!.selectWorkplace = storeFilter!.workplace;
      storeFilter!.selectPriority = storeFilter!.priority;
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "quests.filter.btn".tr(),
          style: TextStyle(
            fontSize: 17,
            color: Color(0xFF1D2127),
          ),
        ),
        centerTitle: true,
        leading: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_sharp,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Observer(
      builder: (_) {
        return storeFilter!.isLoading
            ? Center(
                heightFactor: double.maxFinite,
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 30,
                  height: 30,
                ),
              )
            : ListView.builder(
                cacheExtent: 2500,
                itemCount: storeFilter!.skillFilters.length + 4,
                addAutomaticKeepAlives: true,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0) _radioButton(),
                      if (index == 1)
                        profile!.userData!.role == UserRole.Worker
                            ? Column(
                                children: [
                                  // _checkButton(
                                  //   title: "quests.quests".tr(),
                                  //   list: storeFilter!.sortByQuest,
                                  //   selected: storeFilter!.selectQuest,
                                  //   onChange: storeFilter!.setSelectedQuest,
                                  // ),
                                  _checkButton(
                                    title: "quests.filter.deliveryTime".tr(),
                                    list: storeFilter!.sortByQuestDelivery,
                                    selected: storeFilter!.selectQuestDelivery,
                                    onChange:
                                        storeFilter!.setSelectedQuestDelivery,
                                  ),
                                  _checkButton(
                                    title: "quests.employment.title".tr(),
                                    list: storeFilter!.sortByEmployment,
                                    selected: storeFilter!.selectEmployment,
                                    onChange: (bool? value, int index) {
                                      storeFilter!.setSelectedEmployment(
                                        value,
                                        index,
                                      );
                                      storeFilter!.employment[index] =
                                          value ?? false;
                                    },
                                  ),
                                  _checkButton(
                                    title: "quests.workplace".tr(),
                                    list: storeFilter!.sortByWorkplace,
                                    selected: storeFilter!.selectWorkplace,
                                    onChange: (bool? value, int index) {
                                      storeFilter!.setSelectedWorkplace(
                                        value,
                                        index,
                                      );
                                      storeFilter!.workplace[index] =
                                          value ?? false;
                                    },
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _checkButton(
                                    title: "quests.filter.priorityOfTheEmployee"
                                        .tr(),
                                    list: storeFilter!.sortByPriority,
                                    selected: storeFilter!.selectPriority,
                                    onChange: storeFilter!.setSelectedPriority,
                                  ),
                                  _checkButton(
                                    title: "quests.filter.employeeRating".tr(),
                                    list: storeFilter!.sortByEmployeeRating,
                                    selected: storeFilter!.selectEmployeeRating,
                                    onChange:
                                        storeFilter!.setSelectedEmployeeRating,
                                  ),
                                  _checkButton(
                                    title: "quests.workplace".tr(),
                                    list: storeFilter!.sortByWorkplace,
                                    selected: storeFilter!.selectWorkplace,
                                    onChange: storeFilter!.setSelectedWorkplace,
                                  ),
                                ],
                              ),
                      if (index == 2)
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "filters.dd.1".tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (index > 2 && index != 30)
                        ExpansionCell(
                          storeFilter!.skillFilters[index - 2]!,
                          index - 2,
                          storeQuest,
                        ),
                      if (index == storeFilter!.skillFilters.length + 3)
                        bottomButtons(),
                    ],
                  );
                },
              );
      },
    );
  }

  Widget bottomButtons() => Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 30.0,
        ),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                storeQuest.getQuests(true);
                Navigator.pop(context);
              },
              child: Text(
                "meta.accept".tr(),
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(
                  Size(double.maxFinite, 43),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5);
                    return const Color(0xFF0083C7);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            OutlinedButton(
              onPressed: () {
                storeQuest.selectedSkill.clear();
                storeQuest.getQuests(true);
                Navigator.pop(context);
              },
              child: Text(
                "meta.reset".tr(),
              ),
              style: OutlinedButton.styleFrom(
                fixedSize: Size(double.maxFinite, 43),
                side: BorderSide(
                  width: 1.0,
                  color: Color(0xFF0083C7).withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _radioButton() => ExpansionTile(
        title: Text(
          "quests.filter.sortBy.title".tr(),
        ),
        children: [
          for (int i = 0; i < storeFilter!.sortBy.length; i++)
            Observer(
              builder: (_) => RadioListTile<String>(
                title: Text(
                  storeFilter!.sortBy[i],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: false,
                ),
                value: storeFilter!.sortBy[i],
                groupValue: storeFilter!.selectSortBy,
                onChanged: storeFilter!.setSortBy,
              ),
            )
        ],
      );

  Widget _checkButton({
    required title,
    required List<String> list,
    required ObservableList<bool> selected,
    required Function onChange,
  }) =>
      ExpansionTile(
        maintainState: true,
        title: Text(title),
        children: [
          for (int i = 0; i < list.length; i++)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Observer(
                    builder: (_) => Checkbox(
                      checkColor: Colors.white,
                      value: selected[i],
                      onChanged: (bool? value) => onChange(value, i),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      list[i],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ExpansionCell<T> extends StatefulWidget {
  final List<int> filter;
  final int index;
  final QuestsStore storeQuest;

  const ExpansionCell(this.filter, this.index, this.storeQuest);

  @override
  State<ExpansionCell> createState() => _ExpansionCellState();
}

class _ExpansionCellState extends State<ExpansionCell> {
  List<bool> selected = [];
  String selectRadioValue = "";

  @override
  void initState() {
    setState(
      () {
        selected = List.generate(widget.filter.length, (index) => false);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          maintainState: true,
          title: Text(
            "filters.items.${widget.index}.title".tr(),
          ),
          children: [
            for (int i = 0; i < widget.filter.length; i++)
              getCheckbox(
                i,
                "filters.items.${widget.index}.sub.${widget.filter[i]}".tr(),
                widget.index,
                widget.filter[i],
              ),
          ],
        ),
      ],
    );
  }

  Widget getCheckbox(int index, String text, int spec, int skill) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            value: selected[index],
            onChanged: (bool? value) {
              setState(
                () {
                  selected[index] = value!;
                  if (value == true)
                    widget.storeQuest.addSkill("$spec.$skill");
                  else
                    widget.storeQuest.deleteSkill("$spec.$skill");
                },
              );
            },
          ),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
