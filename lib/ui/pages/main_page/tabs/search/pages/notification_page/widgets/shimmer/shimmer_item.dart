import 'package:app/ui/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerItem extends StatelessWidget {
  final double height;
  final double width;

  const ShimmerItem({
    Key? key,
    required this.height,
    required this.width,
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