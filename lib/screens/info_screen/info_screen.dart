import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/providers/theme_provider.dart';
import 'package:pomodoro/screens/info_screen/components/language_section.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_notifier.dart';
import '../../services/auth_methods.dart';
import '../../services/language_service.dart';
import '../../services/storage_data.dart';
import '../../utils/ThemeColor.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

List<dynamic> themesList = [beigeTheme, pinkTheme, greenTheme];
List<dynamic> colorCircle = [beigePrimary, pinkPrimary, greenPrimary];

class _InfoScreenState extends State<InfoScreen> {
  late String _language;

  @override
  void initState() {
    super.initState();
    _language = I18nService().locale == const Locale('vi', 'VN') ? 'vi' : 'en';
  }

  // Language
  _handleChangeLanguage(String newValue) {
    if (newValue == "system") {
      I18nService().syncToSystem();
    } else {
      I18nService().changeLocale(newValue);
    }
    setState(() {
      _language = newValue;
    });

    // Get.offAllNamed(Routes.splash);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final authMethods = Provider.of<AuthMethods>(context);
    final size = MediaQuery.of(context).size;
    final authNotifier = Provider.of<AuthNotifier>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                SizedBox(
                  width: size.width * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      authNotifier.userDetails.avatar,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  child: Text(
                    authNotifier.userDetails.userName,
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
                ExpansionTile(
                    backgroundColor: Theme.of(context).accentColor,
                    title: Text('theme'.tr),
                    children: [
                      Row(
                        children: List.generate(
                          3,
                          (index) => Row(children: [
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                themeNotifier.setTheme(themesList[index]);
                              },
                              child: Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  border: Border.all(
                                    color: themeNotifier.getTheme() ==
                                            themesList[index]
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: colorCircle[index],
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ]),
                LanguageSection(
                    lang: _language, onClick: _handleChangeLanguage),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ElevatedButton(
                    child: Text('log_out'.tr + '!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        primary: Colors.black,
                        onPrimary: Colors.white,
                        fixedSize: const Size(150,
                            40)), //El ancho de deja en 0 porque el "expanded" lo define.
                    onPressed: () async {
                      String logoutType = SavingDataLocally.getAuthMethods();
                      switch (logoutType) {
                        case 'facebook auth':
                          await authMethods.facebookSignOut(
                              authNotifier, context);
                          break;
                        case 'google auth':
                          await authMethods.googleSignOut(
                              context, authNotifier);
                          print('ok');
                          break;
                        default:
                          await authMethods.signOut(authNotifier, context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
