import 'package:app/ui/pages/main_page/chat_page/widgets/shimmer/shimmer_item.dart';
import 'package:flutter/material.dart';

class ShimmerChatItem extends StatelessWidget {
  const ShimmerChatItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: ShimmerItem(
                    width: 56,
                    height: 56,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShimmerItem(width: double.infinity, height: 20),
                    const SizedBox(height: 5),
                    ShimmerItem(width: double.infinity, height: 20),
                    const SizedBox(height: 5),
                    ShimmerItem(width: 50, height: 20),
                  ],
                ),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Color(0xFFF7F8FA),
        )
      ],
    );
  }
}