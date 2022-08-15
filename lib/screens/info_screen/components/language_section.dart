import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/language_service.dart';

class LanguageSection extends StatefulWidget {
  LanguageSection({Key? key, required this.lang, required this.onClick})
      : super(key: key);
  String lang;
  Function(String lang) onClick;
  @override
  State<LanguageSection> createState() => _LanguageSectionState();
}

String currentLanguage = "vi".tr;

class _LanguageSectionState extends State<LanguageSection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentLanguage = I18nService().getTextLang() ?? 'en'.tr;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        ExpansionTile(
            backgroundColor: Theme.of(context).accentColor,
            title: Text(currentLanguage), children: [
          ListTile(
              title: Text("vi".tr),
              trailing: Radio(
                activeColor: Colors.black,
                  value: 'vi',
                  groupValue: widget.lang,
                  onChanged: (value) {
                    widget.onClick('vi');
                    setState(() {
                      currentLanguage = "vi".tr;
                      I18nService().setTextLang(currentLanguage);
                    });
                  }),
              onTap: () {
                widget.onClick('vi');
                setState(() {
                  currentLanguage = "vi".tr;
                  I18nService().setTextLang(currentLanguage);
                });
              }),
          ListTile(

              title: Text("en".tr),
              trailing: Radio(
                  activeColor: Colors.black,
                  value: 'en',
                  groupValue: widget.lang,
                  onChanged: (value) {
                    widget.onClick('en');
                    setState(() {
                      currentLanguage = "en".tr;
                      I18nService().setTextLang(currentLanguage);
                    });
                  }),
              onTap: () {
                widget.onClick('en');
                setState(() {
                  currentLanguage = "en".tr;
                  I18nService().setTextLang(currentLanguage);
                });
              }),
          ListTile(

              title: Text("system_mode".tr),
              trailing: Radio(
                activeColor: Colors.black,
                value: 'system',
                groupValue: widget.lang,
                onChanged: (value) {
                  widget.onClick('system');
                  setState(() {
                    currentLanguage = "system_mode".tr;
                    I18nService().setTextLang(currentLanguage);
                  });
                },
              ),
              onTap: () {
                widget.onClick('system');
                setState(() {
                  currentLanguage = "system_mode".tr;
                  I18nService().setTextLang(currentLanguage);
                });
              }),
        ]
          // onExpansionChanged:,
        ),
      ],
    );
  }
}