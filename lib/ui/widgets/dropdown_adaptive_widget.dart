import 'dart:io';

import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _styleTextItem = TextStyle(color: Colors.black);

class DropDownAdaptiveWidget<T> extends StatefulWidget {
  final T value;
  final List<T> items;
  final dynamic Function(dynamic value) onChanged;
  final Color colorText;
  final bool haveIcon;

  const DropDownAdaptiveWidget({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.items,
    this.colorText = Colors.white,
    this.haveIcon = false,
  }) : super(key: key);

  @override
  _DropDownAdaptiveWidgetState<T> createState() =>
      _DropDownAdaptiveWidgetState<T>();
}

class _DropDownAdaptiveWidgetState<T> extends State<DropDownAdaptiveWidget> {
  @override
  Widget build(BuildContext context) {
    final _isWorkNet = _getTitleItem(widget.value.toString()) == 'WORKNET';

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 50,
        maxHeight: 50,
        minWidth: 150,
        maxWidth: 200,
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.haveIcon)
                if (_isWorkNet)
                  GradientIcon(
                    SvgPicture.asset(
                      _getPathIcons(
                        _getTitleItem(
                          widget.value.toString(),
                        ),
                      ),
                      width: 24,
                      height: 24,
                    ),
                    24,
                  )
                else
                  SvgPicture.asset(
                    _getPathIcons(
                      _getTitleItem(
                        widget.value.toString(),
                      ),
                    ),
                    width: 24,
                    height: 24,
                  ),
              const SizedBox(
                width: 16,
              ),
              Text(
                _getTitleItem(widget.value.toString()),
                style: TextStyle(
                  fontSize: 16,
                  color: widget.colorText,
                ),
              ),
              const SizedBox(
                width: 32,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: widget.colorText,
              ),
            ],
          ),
          if (Platform.isAndroid)
            Positioned.fill(
              child: Opacity(
                opacity: 0.0,
                child: DropdownCard(
                  child: DropdownButton<T>(
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    iconEnabledColor: Colors.white,
                    value: widget.value,
                    isDense: true,
                    items: widget.items
                        .map((e) => DropdownMenuItem<T>(
                              value: e,
                              onTap: () {},
                              child: Text(
                                widget.haveIcon
                                    ? _getName(_getTitleItem(e.toString()))
                                    : _getTitleItem(e.toString()),
                                style: _styleTextItem,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) => widget.onChanged(value),
                  ),
                ),
              ),
            ),
          if (Platform.isIOS)
            Positioned.fill(
              child: InkWell(
                onTap: () {
                  final List<T> children = widget.items as List<T>;
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    builder: (BuildContext context) {
                      T changedEmployment = widget.value;
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
                                  initialItem: children.indexOf(widget.value),
                                ),
                                itemExtent: 32.0,
                                onSelectedItemChanged: (int index) {
                                  changedEmployment = children[index];
                                },
                                children: children
                                    .map((e) => Center(
                                        child: Text(widget.haveIcon
                                            ? _getName(
                                                _getTitleItem(e.toString()))
                                            : _getTitleItem(e.toString()))))
                                    .toList(),
                              ),
                            ),
                            CupertinoButton(
                              child: const Text("OK"),
                              onPressed: () {
                                widget.onChanged(changedEmployment);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(),
              ),
            )
        ],
      ),
    );
  }

  String _getPathIcons(String value) {
    if (value == 'WORKNET') {
      return 'assets/svg/wq_logo.svg';
    } else if (value == 'ETH') {
      return 'assets/svg/eth_logo.svg';
    } else if (value == 'BSC') {
      return 'assets/svg/bsc_logo.svg';
    } else {
      return 'assets/svg/polygon_logo.svg';
    }
  }

  String _getTitleItem(String value) {
    final _result = value.split('.').last;
    return '${_result.substring(0, 1).toUpperCase()}${_result.substring(1)}';
  }

  String _getName(String value) {
    if (value == 'WORKNET') {
      return 'WORKNET';
    } else if (value == 'ETH') {
      return 'Ethereum';
    } else if (value == 'BSC') {
      return 'Binance Smart Chain';
    } else {
      return 'POLYGON';
    }
  }
}

class DropdownCard extends StatefulWidget {
  final DropdownButton child;

  const DropdownCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _DropdownCardState createState() => _DropdownCardState();
}

class _DropdownCardState extends State<DropdownCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonHideUnderline(
          child: widget.child,
        ),
      ),
    );
  }
}
