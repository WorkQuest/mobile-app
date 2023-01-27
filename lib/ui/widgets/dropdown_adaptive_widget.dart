import 'package:app/constants.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:app/utils/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

    return InkWell(
      onTap: _showDialog,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 4.0),
        child: Row(
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
                    24)
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
            Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: widget.colorText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showDialog() {
    BottomSheetUtils.showDefaultBottomSheet(
      context,
      height: 275,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color(0xffE9EDF2),
            ),
          ),
          const SizedBox(
            height: 21,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Choose network',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 16.5,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DismissKeyboard(
                child: Column(
                  children: [
                    for (int i = 0; i < widget.items.length; i++)
                      if (widget.value is Network)
                        _ItemEnvironmentWidget(
                          isEnabled: widget.value == widget.items[i],
                          onPressed: () {
                            widget.onChanged(widget.items[i]);
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          title: _getName(
                              _getTitleItem(widget.items[i].toString())),
                        )
                      else
                        _ItemNetworkWidget(
                          isEnabled: widget.value == widget.items[i],
                          onPressed: () {
                            widget.onChanged(widget.items[i]);
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          title: _getName(
                              _getTitleItem(widget.items[i].toString())),
                          pathIcon: widget.haveIcon
                              ? _getPathIcons(
                                  _getTitleItem(widget.items[i].toString()))
                              : null,
                          haveGradient:
                              _getTitleItem(widget.items[i].toString()) ==
                                  'WORKNET',
                        )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _getPathIcons(String value) {
    if (value == 'WORKNET') {
      return 'assets/wq_logo.svg';
    } else if (value == 'ETH') {
      return 'assets/eth_logo.svg';
    } else if (value == 'BSC') {
      return 'assets/bsc_logo.svg';
    } else {
      return 'assets/polygon_logo.svg';
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
    } else if (value == 'POLYGON') {
      return 'Polygon';
    } else {
      return value;
    }
  }
}

class _ItemEnvironmentWidget extends StatelessWidget {
  final bool isEnabled;
  final String title;
  final Function() onPressed;

  const _ItemEnvironmentWidget({
    Key? key,
    required this.isEnabled,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            if (isEnabled)
              Icon(Icons.check, color: AppColor.enabledButton, size: 25),
            const SizedBox(
              width: 4.0,
            )
          ],
        ),
      ),
    );
  }
}

class _ItemNetworkWidget extends StatelessWidget {
  final bool isEnabled;
  final String? pathIcon;
  final String title;
  final Function() onPressed;
  final bool haveGradient;

  const _ItemNetworkWidget({
    Key? key,
    required this.isEnabled,
    required this.pathIcon,
    required this.title,
    required this.onPressed,
    this.haveGradient = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            if (pathIcon != null)
              if (haveGradient)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: GradientIcon(
                      SvgPicture.asset(pathIcon!, width: 24, height: 24), 35),
                )
              else
                SvgPicture.asset(pathIcon!, width: 24, height: 24),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            if (isEnabled)
              const Icon(
                Icons.check,
                color: AppColor.enabledButton,
              ),
            const SizedBox(
              width: 4.0,
            )
          ],
        ),
      ),
    );
  }
}
