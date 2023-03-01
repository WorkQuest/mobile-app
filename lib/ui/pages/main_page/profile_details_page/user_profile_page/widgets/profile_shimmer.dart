import 'package:flutter/material.dart';

import '../../../../../widgets/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _ShimmerItem(width: double.infinity, height: 280),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < 4; i++) info(),
              socialMedia(),
              const SizedBox(height: 15),
              contactInfo(),
              ratingInfo(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }

  Widget info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShimmerItem(width: 50, height: 20),
        const SizedBox(height: 5),
        _ShimmerItem(width: 100, height: 20),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget socialMedia() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ShimmerItem(width: 70, height: 50),
        _ShimmerItem(width: 70, height: 50),
        _ShimmerItem(width: 70, height: 50),
        _ShimmerItem(width: 70, height: 50),
      ],
    );
  }

  Widget contactInfo() {
    return Column(
      children: [
        _ShimmerItem(width: 200, height: 20),
        const SizedBox(height: 10),
        _ShimmerItem(width: 200, height: 20),
        const SizedBox(height: 10),
        _ShimmerItem(width: 200, height: 20),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget ratingInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ShimmerItem(width: 161, height: 140),
        _ShimmerItem(width: 161, height: 140),
      ],
    );
  }
}

class _ShimmerItem extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerItem({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.stand(
      child: Container(
        child: SizedBox(
          height: height,
          width: width,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
      ),
    );
  }
}
