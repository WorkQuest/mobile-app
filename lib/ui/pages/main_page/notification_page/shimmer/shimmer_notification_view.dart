import 'package:app/ui/pages/main_page/notification_page/shimmer/shimmer_item.dart';
import 'package:flutter/material.dart';

class ShimmerNotificationView extends StatelessWidget {
  const ShimmerNotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerItem(height: 34, width: 34),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShimmerItem(height: 46, width: 46),
                  const SizedBox(width: 10),
                  ShimmerItem(height: 20, width: 220),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
            child: const ShimmerItem(
              width: 130,
              height: 20,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerItem(height: 40, width: 320),
            ],
          ),
        ],
      ),
    );
  }
}
