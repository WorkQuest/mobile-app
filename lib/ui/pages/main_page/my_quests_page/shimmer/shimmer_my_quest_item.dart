import 'package:app/ui/pages/main_page/my_quests_page/shimmer/shimmer_item.dart';
import 'package:flutter/material.dart';

class ShimmerMyQuestItem extends StatelessWidget {
  const ShimmerMyQuestItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const ShimmerItem(
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(width: 5),
              const ShimmerItem(
                width: 140,
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(width: 5),
                  const ShimmerItem(width: 40, height: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 17.5),
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF7C838D),
                  ),
                  const SizedBox(width: 9),
                  const ShimmerItem(width: 60, height: 20),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
          const ShimmerItem(width: 50, height: 20),
          const SizedBox(height: 10),
          const ShimmerItem(width: 250, height: 40),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ShimmerItem(width: 60, height: 20),
              SizedBox(width: 50),
              const ShimmerItem(width: 70, height: 20),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}