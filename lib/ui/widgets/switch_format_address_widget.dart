import 'package:app/constants.dart';
import 'package:app/utils/modal_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SwitchFormatAddressWidget extends StatefulWidget {
  final FormatAddress format;
  final Function(FormatAddress value) onChanged;

  const SwitchFormatAddressWidget({
    Key? key,
    required this.format,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SwitchFormatAddressWidget> createState() => _SwitchFormatAddressWidgetState();
}

class _SwitchFormatAddressWidgetState extends State<SwitchFormatAddressWidget> {
  late FormatAddress _format;

  @override
  void initState() {
    _format = widget.format;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: _onPressedSwitchFormatAddress,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: AppColor.disabledButton,
          ),
        ),
        child: Row(
          children: [
            Text(
              _format.name,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            SvgPicture.asset('assets/arrow_dropdown_icon.svg'),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }

  _onPressedSwitchFormatAddress() {
    ModalBottomSheet.openModalBottomSheet(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'wallet.chooseAddressType'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            children: FormatAddress.values.map((format) {
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    _format = format;
                    widget.onChanged.call(format);
                  });
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      child: Row(
                        children: [
                          Text(
                            format.name,
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const Spacer(),
                          if (_format == format)
                            const Icon(
                              Icons.check,
                              color: AppColor.enabledButton,
                            ),
                          const SizedBox(
                            width: 4.5,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 10.0),
    );
  }
}

enum FormatAddress { BECH32, HEX }