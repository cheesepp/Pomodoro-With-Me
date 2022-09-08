import 'package:flutter/material.dart';

class TomatoRounds extends StatelessWidget {
  const TomatoRounds({
    Key? key,
    required this.rounds,
  }) : super(key: key);

  final int rounds;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          rounds,
          (index) => Padding(
                padding: const EdgeInsets.all(3),
                child: Image.asset(
                  'assets/icons/tomatoDone.png',
                  width: 20,
                  height: 20,
                ),
              )),
    );
  }
}
