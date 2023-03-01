import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';

class SelectedItem extends StatelessWidget {
  final Function()? onTap;
  final bool isSelected;
  final String? iconPath;
  final String? title;
  final bool isCoin;

  const SelectedItem({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
    this.isCoin = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppColor.disabledButton,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: AppColor.disabledButton,
          ),
        ),
        child: Row(
          children: [
            if (isSelected)
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColor.enabledButton,
                      AppColor.blue,
                    ],
                  ),
                ),
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: SvgPicture.asset(
                    iconPath!,
                  ),
                ),
              ),
            Text(
              isSelected
                  ? title!
                  : (isCoin ? 'wallet.enterCoin'.tr() : 'swap.choose'.tr(namedArgs: {'object': 'network'})),
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.black : AppColor.disabledText,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 5.5),
              child: SvgPicture.asset('assets/choose_coin_icon.svg'),
            )
          ],
        ),
      ),
    );
  }
}
