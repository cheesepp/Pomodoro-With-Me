import 'package:flutter/material.dart';

import '../../../widgets/digital_clock.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldState,
  })  : _scaffoldState = scaffoldState,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldState;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 30),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white70,
              )),
          Expanded(
            child: Container(),
          ),
          const DigitalClockBuilder(),
          IconButton(
              onPressed: () {
                _scaffoldState.currentState!.openEndDrawer();
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white70,
              )),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
