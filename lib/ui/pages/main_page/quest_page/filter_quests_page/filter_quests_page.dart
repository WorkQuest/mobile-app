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
  final storeFilter = FilterQuestsStore();
  ProfileMeStore? profile;
  late final QuestsStore storeQuest;

  @override
  void initState() {
    storeFilter.readFilters();
    profile = context.read<ProfileMeStore>();
    storeQuest = context.read<QuestsStore>();
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
        return storeFilter.isLoading
            ? Center(
                heightFactor: double.maxFinite,
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 30,
                  height: 30,
                ))
            : ListView.builder(
                itemCount: storeFilter.filters.length,
                addAutomaticKeepAlives: true,
                itemBuilder: (context, index) {
                  return storeFilter.filters[index].type == TypeFilter.Check
                      ? ExpansionCell(storeFilter.filters[index])
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _radioButton(),
                            profile!.userData!.role == UserRole.Worker
                                ? Column(
                                    children: [
                                      _checkButton(
                                        title: "quests.quests".tr(),
                                        list: storeFilter.sortByQuest,
                                        selected: storeFilter.selectQuest,
                                        onChange: storeFilter.setSelectedQuest,
                                      ),
                                      _checkButton(
                                        title:
                                            "quests.quests.deliveryTime".tr(),
                                        list: storeFilter.sortByQuestDelivery,
                                        selected:
                                            storeFilter.selectQuestDelivery,
                                        onChange: storeFilter
                                            .setSelectedQuestDelivery,
                                      ),
                                      _checkButton(
                                        title: "quests.employment.title".tr(),
                                        list: storeFilter.sortByEmployment,
                                        selected: storeFilter.selectEmployment,
                                        onChange: (bool? value, int i) {
                                          storeFilter.setSelectedEmployment(
                                            value,
                                            i,
                                          );
                                          storeQuest.employment =
                                              storeFilter.sortByEmployment[i];
                                          storeQuest.getEmploymentValue();
                                        },
                                      ),
                                      _checkButton(
                                        title: "quests.workplace".tr(),
                                        list: storeFilter.sortByWorkplace,
                                        selected: storeFilter.selectWorkplace,
                                        onChange: (bool? value, int i) {
                                          storeFilter.setSelectedWorkplace(
                                            value,
                                            i,
                                          );
                                          storeQuest.workplace =
                                              storeFilter.sortByWorkplace[i];
                                          storeQuest.getWorkplaceValue();
                                        },
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _checkButton(
                                        title:
                                            "quests.filter.priorityOfTheEmployee"
                                                .tr(),
                                        list: storeFilter.sortByPriority,
                                        selected: storeFilter.selectPriority,
                                        onChange:
                                            storeFilter.setSelectedPriority,
                                      ),
                                      _checkButton(
                                        title:
                                            "quests.filter.employeeRating".tr(),
                                        list: storeFilter.sortByEmployeeRating,
                                        selected:
                                            storeFilter.selectEmployeeRating,
                                        onChange: storeFilter
                                            .setSelectedEmployeeRating,
                                      ),
                                      _checkButton(
                                        title: "quests.workplace".tr(),
                                        list: storeFilter.sortByWorkplace,
                                        selected: storeFilter.selectWorkplace,
                                        onChange:
                                            storeFilter.setSelectedWorkplace,
                                      ),
                                    ],
                                  ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "filters.dd.1".tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                },
              );
      },
    );
  }

  Widget _radioButton() => ExpansionTile(
        title: Text(
          "quests.filter.sortBy.title".tr(),
        ),
        children: [
          for (int i = 0; i < storeFilter.sortBy.length; i++)
            Observer(
              builder: (_) => RadioListTile<String>(
                title: Text(
                  storeFilter.sortBy[i],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: false,
                ),
                value: storeFilter.sortBy[i],
                groupValue: storeFilter.selectSortBy,
                onChanged: storeFilter.setSortBy,
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
  final FilterItem filter;

  const ExpansionCell(this.filter);

  @override
  State<ExpansionCell> createState() => _ExpansionCellState();
}

class _ExpansionCellState extends State<ExpansionCell> {
  List<bool> selected = [];
  String selectRadioValue = "";

  @override
  void initState() {
    setState(() {
      selected = List.generate(widget.filter.list.length, (index) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Text("filters.${widget.filter.header}.title".tr()),
          children: [
            for (int i = 0; i < widget.filter.list.length; i++)
              getCheckbox(
                i,
                "filters.${widget.filter.header}.sub.${widget.filter.list[i]}"
                    .tr(),
              ),
          ],
        ),
      ],
    );
  }

  Widget getCheckbox(int index, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            value: selected[index],
            onChanged: (bool? value) {
              setState(() {
                selected[index] = value!;
              });
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
