import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/quest_page/filter_quests_page/store/filter_quests_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';
import "package:provider/provider.dart";

import '../../../../../constants.dart';

class FilterQuestsPage extends StatefulWidget {
  const FilterQuestsPage(this.filters);

  final Map<int, List<int>> filters;
  static const String routeName = '/filterQuestPage';

  @override
  State<FilterQuestsPage> createState() => _FilterQuestsPageState();
}

class _FilterQuestsPageState extends State<FilterQuestsPage>
    with AutomaticKeepAliveClientMixin {
  FilterQuestsStore? storeFilter;
  ProfileMeStore? profile;
  late final QuestsStore storeQuest;
  late TextEditingController fromPriceController;
  late TextEditingController toPriceController;

  @override
  void initState() {
    storeFilter = context.read<FilterQuestsStore>();
    profile = context.read<ProfileMeStore>();
    storeQuest = context.read<QuestsStore>();
    fromPriceController = TextEditingController(text: storeQuest.fromPrice)
      ..addListener(() {
        storeFilter!.setFromPrice(fromPriceController.text);
      });
    toPriceController = TextEditingController(text: storeQuest.toPrice)
      ..addListener(() {
        storeFilter!.setToPrice(toPriceController.text);
      });
    storeFilter!.getFilters(storeQuest.selectedSkill, widget.filters);
    // storeFilter!.initSkillFiltersValue(storeQuest.selectedSkillFilters);
    storeFilter!.initEmployments(storeQuest.employments);
    storeFilter!.initRating(storeQuest.employeeRatings);
    storeFilter!.initWorkplace(storeQuest.workplaces);
    storeFilter!.initPriority(storeQuest.priorities);
    storeFilter!.initSort(storeQuest.sort);
    super.initState();
  }

  Widget build(BuildContext context) {
    super.build(context);
    return DismissKeyboard(
      child: Scaffold(
        persistentFooterButtons: [
          bottomButtons(),
        ],
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
      ),
    );
  }

  Widget getBody() {
    return Observer(
      builder: (_) {
        return storeFilter!.isLoading
            ? Center(
                heightFactor: double.maxFinite,
                child: SizedBox(
                  child: CircularProgressIndicator.adaptive(),
                  width: 30,
                  height: 30,
                ),
              )
            : ListView.builder(
                cacheExtent: 2500,
                itemCount: storeFilter!.skillFilters.length + 5,
                addAutomaticKeepAlives: true,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0) _radioButton(),
                      if (index == 1)
                        ExpansionTile(
                          collapsedBackgroundColor:
                              fromPriceController.text.isNotEmpty ||
                                      toPriceController.text.isNotEmpty
                                  ? Color(0xFF0083C7).withOpacity(0.1)
                                  : Colors.white,
                          expandedAlignment: Alignment.topLeft,
                          title: Text(
                            "Price",
                          ),
                          childrenPadding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 16.0,
                          ),
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'From',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      child: TextField(
                                        controller: fromPriceController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: '0 WUSD',
                                          suffixIcon: IconButton(
                                            splashRadius: 0.1,
                                            onPressed:
                                                fromPriceController.clear,
                                            icon: Icon(
                                              Icons.close,
                                              color: AppColor.enabledButton,
                                            ),
                                          ),
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^[0-9]*'),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'To',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      child: TextFormField(
                                        controller: toPriceController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: '10000 WUSD',
                                          suffixIcon: IconButton(
                                            splashRadius: 0.1,
                                            onPressed: toPriceController.clear,
                                            icon: Icon(
                                              Icons.close,
                                              color: AppColor.enabledButton,
                                            ),
                                          ),
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^[0-9]*'),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (index == 2)
                        profile!.userData!.role == UserRole.Worker
                            ? Column(
                                children: [
                                  _checkButton(
                                    title: "quests.filter.deliveryTime".tr(),
                                    list: storeFilter!.sortByPriority,
                                    selected: storeFilter!.priority,
                                    onChange: storeFilter!.setSelectedPriority,
                                  ),
                                  _checkButton(
                                    title: "quests.type".tr(),
                                    list: storeFilter!.sortByEmployment,
                                    selected: storeFilter!.selectEmployment,
                                    onChange: (bool? value, int index) {
                                      storeFilter!.setSelectedEmployment(
                                        value,
                                        index,
                                      );
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
                                      storeFilter!.selectWorkplace[index] =
                                          value ?? false;
                                    },
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _checkButton(
                                    title: "quests.rating".tr(),
                                    list: storeFilter!.sortByEmployeeRating,
                                    selected: storeFilter!.selectEmployeeRating,
                                    onChange:
                                        storeFilter!.setSelectedEmployeeRating,
                                  ),
                                  _checkButton(
                                    title: "settings.priority".tr(),
                                    list: storeFilter!.sortByPriority,
                                    selected: storeFilter!.priority,
                                    onChange: storeFilter!.setSelectedPriority,
                                  ),
                                  _checkButton(
                                    title: "quests.workplace".tr(),
                                    list: storeFilter!.sortByWorkplace,
                                    selected: storeFilter!.selectWorkplace,
                                    onChange: storeFilter!.setSelectedWorkplace,
                                  ),
                                ],
                              ),
                      if (index == 3)
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "filters.dd.1".tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (index > 3 && index != 31)
                        ExpansionCell(
                          storeFilter!.skillFilters[index - 3]!,
                          index - 3,
                          storeQuest,
                          storeFilter!,
                        ),
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
        ),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                storeQuest.setEmployment(storeFilter!.getEmploymentValue());
                storeQuest.setWorkplace(storeFilter!.getWorkplaceValue());
                storeQuest.setPriority(storeFilter!.getPriorityValue());
                storeQuest.setSortBy(storeFilter!.getSortByValue());
                storeQuest.setEmployeeRating(storeFilter!.getEmployeeRating());
                storeQuest.setPrice(
                    fromPriceController.text, toPriceController.text);
                storeQuest.setSkillFilters(storeFilter!.selectedSkill);
                storeQuest
                    .setSelectedSkillFilters(storeFilter!.selectedSkillFilters);
                profile!.userData!.role == UserRole.Employer
                    ? storeQuest.getWorkers(true)
                    : storeQuest.getQuests(true);
                Navigator.pop(context);
              },
              child: Text(
                "meta.accept".tr(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            OutlinedButton(
              onPressed: () {
                storeQuest.clearFilters();
                storeFilter!.clearFilters();
                profile!.userData!.role == UserRole.Employer
                    ? storeQuest.getWorkers(true)
                    : storeQuest.getQuests(true);
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
        collapsedBackgroundColor: storeFilter!.selectSortBy.isNotEmpty
            ? Color(0xFF0083C7).withOpacity(0.1)
            : Colors.white,
        children: [
          for (int i = 0; i < storeFilter!.sortBy.length; i++)
            Observer(
              builder: (_) => RadioListTile<String>(
                title: Text(
                  storeFilter!.sortBy[i].tr(),
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
      Observer(
        builder: (_) => ExpansionTile(
          collapsedBackgroundColor: selected
                  .firstWhere((element) => element == true, orElse: () => false)
              ? Color(0xFF0083C7).withOpacity(0.1)
              : Colors.white,
          maintainState: true,
          title: Text(title),
          children: [
            for (int i = 0; i < list.length; i++)
              CheckboxListTile(
                title: Text(
                  list[i].tr(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: false,
                ),
                value: selected[i],
                onChanged: (bool? value) => onChange(value, i),
                controlAffinity: ListTileControlAffinity.leading,
              ),
          ],
        ),
      );

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ExpansionCell<T> extends StatefulWidget {
  final List<int> filter;
  final int index;
  final QuestsStore storeQuest;
  final FilterQuestsStore storeFilter;

  const ExpansionCell(
    this.filter,
    this.index,
    this.storeQuest,
    this.storeFilter,
  );

  @override
  State<ExpansionCell> createState() => _ExpansionCellState();
}

class _ExpansionCellState extends State<ExpansionCell> {
  String selectRadioValue = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Observer(
          builder: (_) => ExpansionTile(
            collapsedBackgroundColor:
                widget.storeFilter.selectedSkillFilters[widget.index - 1] !=
                        null
                    ? widget.storeFilter.selectedSkillFilters[widget.index - 1]!
                            .firstWhere((element) => element == true,
                                orElse: () => false)
                        ? Color(0xFF0083C7).withOpacity(0.1)
                        : Colors.white
                    : Colors.white,
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
        ),
      ],
    );
  }

  Widget getCheckbox(int index, String text, int spec, int skill) {
    return CheckboxListTile(
      title: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        softWrap: false,
      ),
      value: widget.storeFilter.selectedSkillFilters[widget.index - 1]![index],
      onChanged: (bool? value) {
        widget.storeFilter.selectedSkillFilters[widget.index - 1]![index] =
            value!;
        if (value == true)
          widget.storeFilter.addSkill("$spec.$skill");
        else
          widget.storeFilter.deleteSkill("$spec.$skill");
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
