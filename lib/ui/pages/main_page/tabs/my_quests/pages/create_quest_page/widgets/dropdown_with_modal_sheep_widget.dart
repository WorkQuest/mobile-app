import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDownWithModalSheepWidget extends StatelessWidget {
  final String value;
  final List<String> children;
  final Function(String) onPressed;

  const DropDownWithModalSheepWidget({
    Key? key,
    required this.value,
    required this.children,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Row(
        children: [
          Text(
            value.tr(),
            style: TextStyle(color: Colors.black87),
          ),
          Spacer(),
          Icon(
            Icons.arrow_drop_down,
            size: 30,
            color: Colors.blueAccent,
          )
        ],
      ),
      padding: EdgeInsets.zero,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          builder: (BuildContext context) {
            var changedEmployment = value;
            return Container(
              height: 150.0 + MediaQuery.of(context).padding.bottom,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: children.indexOf(value),
                      ),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        changedEmployment = children[index];
                      },
                      children: children
                          .map((e) => Center(child: Text(e.tr())))
                          .toList(),
                    ),
                  ),
                  CupertinoButton(
                    child: Text("OK"),
                    onPressed: () {
                      onPressed.call(changedEmployment);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
