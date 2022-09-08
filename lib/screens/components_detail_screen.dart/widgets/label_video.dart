import 'package:flutter/material.dart';

import '../../component_detail_screen.dart';

class LabelVideo extends StatelessWidget {
  const LabelVideo({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ComponentDetailScreen widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.component.name,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white70,
        fontSize: 25,
      ),
    );
  }
}
