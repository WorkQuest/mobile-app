import 'package:app/constants.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:flutter/cupertino.dart';
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
  _DropDownAdaptiveWidgetState<T> createState() => _DropDownAdaptiveWidgetState<T>();
}

class _DropDownAdaptiveWidgetState<T> extends State<DropDownAdaptiveWidget> {
  @override
  Widget build(BuildContext context) {
    final _isWorkNet = _getTitleItem(widget.value.toString()) == 'WORKNET';

    return InkWell(
      onTap: _showDialog,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            if (widget.value is Network)
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
              )
          ],
        ),
      ),
    );
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.only(top: 10, left: 8.0, right: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          scrollable: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select network'),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              )
            ],
          ),
          content: SizedBox(
            height: 250.0,
            width: 250.0,
            child: Scrollbar(
              child: ListView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                shrinkWrap: true,
                children: [
                  for (int i = 0; i < widget.items.length; i++)
                    if (widget.value is Network)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            color: const Color(0xc1e2e2e2),
                          ),
                          _ItemEnvironmentWidget(
                            isEnabled: widget.value == widget.items[i],
                            onPressed: () {
                              widget.onChanged(widget.items[i]);
                              Navigator.pop(context);
                            },
                            title: _getName(_getTitleItem(widget.items[i].toString())),
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            color: const Color(0xc1e2e2e2),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            color: const Color(0xc1e2e2e2),
                          ),
                          _ItemNetworkWidget(
                            isEnabled: widget.value == widget.items[i],
                            onPressed: () {
                              widget.onChanged(widget.items[i]);
                              Navigator.pop(context);
                            },
                            title: _getName(_getTitleItem(widget.items[i].toString())),
                            pathIcon: widget.haveIcon ? _getPathIcons(_getTitleItem(widget.items[i].toString())) : null,
                            haveGradient: _getTitleItem(widget.items[i].toString()) == 'WORKNET',
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            color: const Color(0xc1e2e2e2),
                          ),
                        ],
                      )
                ],
              ),
            ),
          ),
          actionsPadding: EdgeInsets.zero,
          actionsOverflowDirection: VerticalDirection.down,
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 6.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 16, color: AppColor.enabledButton),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            )
          ],
        );
      },
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
      return 'POLYGON';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
      child: CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 46,
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.check, color: isEnabled ? Colors.black : Colors.transparent, size: 25),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
              )
            ],
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
      child: CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 46,
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.check, color: isEnabled ? Colors.black : Colors.transparent, size: 25),
              const SizedBox(width: 5),
              if (pathIcon != null)
                if (haveGradient)
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: GradientIcon(
                      SvgPicture.asset(pathIcon!, width: 35, height: 35),
                      35,
                    ),
                  )
                else
                  SvgPicture.asset(pathIcon!, width: 35, height: 35),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
