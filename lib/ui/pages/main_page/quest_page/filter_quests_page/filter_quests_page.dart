import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/quest_page/filter_quests_page/store/filter_quests_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';
import "package:provider/provider.dart";

class FilterQuestsPage extends StatefulWidget {
  const FilterQuestsPage({Key? key}) : super(key: key);

  @override
  State<FilterQuestsPage> createState() => _FilterQuestsPageState();
}

class _FilterQuestsPageState extends State<FilterQuestsPage> {
  final store = FilterQuestsStore();
  ProfileMeStore? profile;

  @override
  void initState() {
    store.readFilters();
    profile = context.read<ProfileMeStore>();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filters",
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
    return Observer(builder: (_) {
      return store.isLoading
          ? Center(
              heightFactor: double.maxFinite,
              child: SizedBox(
                child: CircularProgressIndicator(),
                width: 30,
                height: 30,
              ))
          : ListView.builder(
              itemCount: store.filters.length,
              itemBuilder: (context, index) {
                return store.filters[index].type == TypeFilter.Check
                    ? ExpansionCell(store.filters[index])
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _radioButton(),
                          profile!.userData!.role == UserRole.Worker
                              ? Column(
                                  children: [
                                    _checkButton(
                                      title: "Quests",
                                      list: store.sortByQuest,
                                      selected: store.selectQuest,
                                      onChange: store.setSelectedQuest,
                                    ),
                                    _checkButton(
                                      title: "Quests delivery time",
                                      list: store.sortByQuestDelivery,
                                      selected: store.selectQuestDelivery,
                                      onChange: store.setSelectedQuestDelivery,
                                    ),
                                    _checkButton(
                                      title: "Employment",
                                      list: store.sortByEmployment,
                                      selected: store.selectEmployment,
                                      onChange: store.setSelectedEmployment,
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _checkButton(
                                      title: "Priority of the employee",
                                      list: store.sortByPriority,
                                      selected: store.selectPriority,
                                      onChange: store.setSelectedPriority,
                                    ),
                                    _checkButton(
                                      title: "Employee rating",
                                      list: store.sortByEmployeeRating,
                                      selected: store.selectEmployeeRating,
                                      onChange: store.setSelectedEmployeeRating,
                                    ),
                                    _checkButton(
                                      title: "Distant work",
                                      list: store.sortByDistantWork,
                                      selected: store.selectDistantWork,
                                      onChange: store.setSelectedWork,
                                    ),
                                  ],
                                ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Specialization",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
              });
    });
  }

  Widget _radioButton() => ExpansionTile(
        title: Text("Sort by"),
        children: [
          for (int i = 0; i < store.sortBy.length; i++)
            Observer(
              builder: (_) => RadioListTile<String>(
                title: Text(
                  store.sortBy[i],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: false,
                ),
                value: store.sortBy[i],
                groupValue: store.selectSortBy,
                onChanged: store.setSortBy,
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
                        onChanged: (bool? value) => onChange(value, i)),
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
