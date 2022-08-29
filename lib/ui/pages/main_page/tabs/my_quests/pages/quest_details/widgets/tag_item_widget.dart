import 'package:flutter/material.dart';

class TagItemWidget extends StatelessWidget {
  final List<String> skills;

  const TagItemWidget({
    Key? key,
    required this.skills,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: skills
          .map(
            (item) => ActionChip(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 10.0,
              ),
              onPressed: () => null,
              label: Text(
                item,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF0083C7),
                ),
              ),
              backgroundColor: Color(0xFF0083C7).withOpacity(0.1),
            ),
          )
          .toList(),
    );
  }
}
