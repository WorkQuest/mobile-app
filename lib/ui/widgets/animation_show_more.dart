import 'package:app/constants.dart';
import 'package:flutter/material.dart';

class AnimationShowMore extends StatelessWidget {
  final String text;
  final bool enabled;
  final Function(bool) onShowMore;

  const AnimationShowMore({
    Key? key,
    required this.text,
    required this.enabled,
    required this.onShowMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            maxLines: enabled ? null : 2,
            overflow: enabled ? TextOverflow.clip : TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 5,),
          InkWell(
            onTap: () {
              onShowMore.call(!enabled);
            },
            child: Text(
              enabled ? 'Show less' : 'Show more',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
