import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemListBottomSheet extends StatelessWidget {
  final String title;
  final String iconPath;
  final Function()? onTap;

  const ItemListBottomSheet({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.5),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 32,
              width: double.infinity,
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
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
                      child: SvgPicture.asset(iconPath),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: AppColor.disabledButton,
        ),
      ],
    );
  }
}
