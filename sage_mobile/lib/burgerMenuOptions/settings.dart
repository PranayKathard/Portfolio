import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:sage_mobile/style/stylesheet.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  /// Initialize platform state.
  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings',
            style: logoWhiteStyle, textAlign: TextAlign.center),
        backgroundColor: Color(0xff99BC1C),
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15, top: 10),
            child: Text("NOTIFICATION SETTINGS",
                style: TextStyle(fontSize: 14.0, color: Colors.blueGrey)),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('Push Notifications',
                                style: TextStyle(color: Colors.black)),
                            Text(
                              'This will take you to your phones "push notification" settings',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                      onPressed: () {
                        AppSettings.openNotificationSettings();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Email latest news',
                            style:
                                TextStyle(color: Colors.black, fontSize: 13)),
                        ToggleSwitch(
                          initialLabelIndex: 0,
                          minWidth: 50.0,
                          minHeight: 20.0,
                          fontSize: 10.0,
                          activeBgColor: Colors.green,
                          activeFgColor: Colors.white,
                          labels: ['Yes', 'No'],
                          onToggle: (index) {
                            print('switched to: $index');
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(left: 15, top: 10),
          //   child: Text("PREFERENCE SETTINGS",
          //       style: TextStyle(color: Colors.blueGrey)),
          // ),
          // Container(
          //   margin: const EdgeInsets.all(10.0),
          //   decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.all(Radius.circular(10))),
          //   child: Center(
          //     child: Column(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.all(20.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text('Dark Mode',
          //                   style:
          //                       TextStyle(color: Colors.black, fontSize: 13)),
          //               ToggleSwitch(
          //                 initialLabelIndex: 0,
          //                 minWidth: 50.0,
          //                 minHeight: 20.0,
          //                 fontSize: 10.0,
          //                 activeBgColor: Colors.green,
          //                 activeFgColor: Colors.white,
          //                 labels: ['Yes', 'No'],
          //                 onToggle: (index) {
          //                   print('switched to: $index');
          //                 },
          //               ),
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
