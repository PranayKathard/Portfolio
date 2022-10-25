import 'package:flutter/material.dart';
import 'package:sage_mobile/models/notification.dart';
import 'package:sage_mobile/services/application_service.dart';
import 'package:sage_mobile/services/service.dart';
import 'package:sage_mobile/style/fryo_icons.dart';

import '../NotificationPage.dart';

class notifications extends StatefulWidget {
  @override
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('Notifications'),
          backgroundColor: Color(0xff99BC1C)),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: ApplicationService.getNotificationsForUser(
                  ApplicationService.user.getID),
              builder:
                  (context, AsyncSnapshot<List<NotificationModel>> snapshot) {
                print(snapshot.hasData);
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Text('Loading...');
                  case ConnectionState.done:
                    if (!snapshot.hasData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 70.0,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.search,
                                size: 60.0,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Currently there are no notifications...',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                    fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Container(
                              height: 90.00,
                              child: ListTile(
                                leading: IconButton(
                                  icon: Icon(Fryo.envelope),
                                  iconSize: 60.00,
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return NotificationPage(
                                              notification:
                                                  snapshot.data![index]);
                                        },
                                      ),
                                    );
                                  },
                                ),
                                title: Text(snapshot.data![index].header),
                                subtitle: Container(
                                  width: 200,
                                  child: Text(
                                    snapshot.data![index].note,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Fryo.trash),
                                  iconSize: 50.00,
                                  color: Colors.black,
                                  onPressed: () {
                                    Service.deleteNotification(
                                        snapshot.data![index].id);
                                    setState(() {
                                      snapshot.data!
                                          .remove(snapshot.data![index]);
                                    });
                                    ApplicationService.numNotifications--;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Message deleted.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    break;
                  default:
                    return Text('default');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
