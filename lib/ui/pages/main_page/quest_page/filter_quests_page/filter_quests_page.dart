import 'package:app/ui/pages/main_page/quest_page/filter_quests_page/store/filter_quests_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';

class FilterQuestsPage extends StatefulWidget {
  const FilterQuestsPage({Key? key}) : super(key: key);

  @override
  State<FilterQuestsPage> createState() => _FilterQuestsPageState();
}

class _FilterQuestsPageState extends State<FilterQuestsPage> {
  final store = FilterQuestsStore();

  @override
  void initState() {
    store.readFilters();
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
              itemBuilder: (context, index) =>
                  ExpensionCell(store.filters[index]));
    });
  }
}

class ExpensionCell<T> extends StatefulWidget {
  final FilterItem filter;

  const ExpensionCell(this.filter);

  @override
  State<ExpensionCell> createState() => _ExpensionCellState();
}

class _ExpensionCellState extends State<ExpensionCell> {
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
          title: widget.filter.type == TypeFilter.Check
              ? Text("filters.${widget.filter.header}.title".tr())
              : Text("Sort by"),
          children: [
            for (int i = 0; i < widget.filter.list.length; i++)
              widget.filter.type == TypeFilter.Check
                  ? getCheckbox(i)
                  : getRadioButton(i)
          ],
        ),
      ],
    );
  }

  Widget getCheckbox(int index) {
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
              "filters.${widget.filter.header}.sub.${widget.filter.list[index]}"
                  .tr(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget getRadioButton(int index) {
    return RadioListTile<String>(
      title: Text(
        "filters.dd.${index + 1}".tr(),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        softWrap: false,
      ),
      value: index.toString(),
      groupValue: selectRadioValue,
      onChanged: (_) {
        setState(() {
          selectRadioValue = index.toString();
        });
      },
    );
  }
}
