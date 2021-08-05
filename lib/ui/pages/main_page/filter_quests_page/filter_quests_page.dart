import 'package:app/ui/pages/main_page/filter_quests_page/store/filter_quests_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
          ),
          onPressed: () => Navigator.of(context).pop(),
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
    return ExpansionTile(
      title: Text(widget.filter.header),
      children: [
        for (int i = 0; i < widget.filter.list.length; i++)
          widget.filter.type == TypeFilter.Radio
              ? getRadioButton(i)
              : getCheckbox(i)
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
              widget.filter.list[index],
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
        widget.filter.list[index],
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
