import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AddressProfileWidget extends StatelessWidget {
  final String address;
  final Function() onTap;

  const AddressProfileWidget({
    Key? key,
    required this.address,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "quests.address".tr(),
            style: TextStyle(fontSize: 16),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFF7F8FA),
                  width: 2,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Flexible(
                    child: Text(
                      address,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
