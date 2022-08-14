import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/utils/ThemeColor.dart';

class SettingDrawer extends StatefulWidget {
  SettingDrawer(
      {Key? key,
      required this.learnDuration,
      required this.breakDuration,
      required this.rounds})
      : super(key: key);
  VoidCallback learnDuration;
  VoidCallback breakDuration;
  VoidCallback rounds;
  @override
  State<SettingDrawer> createState() => _SettingDrawerState();
}

class _SettingDrawerState extends State<SettingDrawer> {
  Widget buildListTile(String title, String icon, Function tapHandler) {
    return ListTile(
      leading: ImageIcon(
        AssetImage(icon),
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler as Function(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:Theme.of(context).accentColor,
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: [
                const SizedBox(
                  height: 70,
                ),
                Text(
                  'drawer_settings'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          buildListTile('drawer_learn'.tr, 'assets/icons/studying.jpg',
              widget.learnDuration),
          buildListTile('drawer_break'.tr, 'assets/icons/relaxing.png',
              widget.breakDuration),
          buildListTile('drawer_rounds'.tr, 'assets/icons/tomato.png', widget.rounds),
        ],
      ),
    );
  }
}
