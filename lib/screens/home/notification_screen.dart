import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';

import '../../services/api_handler.dart';
import '../../services/theme_manager.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> notifications =
      Hive.box('cache').get('notifcations', defaultValue: []).cast<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: NotificationWidget(
              title: "Sự thật thú vị",
              date: notifications[notifications.length - index - 1].split(' ')[0],
              content: notifications[notifications.length - index - 1].split(' ').skip(1).join(' '),
              onDelete: () {
                notifications.removeAt(index);
                Hive.box('cache').put('notifcations', notifications);
                setState(() {
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  final String title;
  final String date;
  final String content;
  final VoidCallback onDelete;

  NotificationWidget({
    required this.title,
    required this.date,
    required this.content,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Card(
      color: myColors.cardBackground,
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(content),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationModel {
  final String title;
  final String date;
  final String content;

  NotificationModel({
    required this.title,
    required this.date,
    required this.content,
  });
}

class NotificationIconRedDot extends StatelessWidget {
  NotificationIconRedDot();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GetIt.I<APIHanlder>().newNotifcations,
        builder: (
          BuildContext context,
          bool newNotifications,
          Widget? child,
        ) {
          return Stack(
            children: <Widget>[
              IconButton(
                icon: Iconify(
                  Carbon.notification_filled,
                  color: Color(0xffe8e01a), // Change color as needed
                  size: 32,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                  GetIt.I<APIHanlder>().newNotifcations.value = false;
                },
              ),
              newNotifications ? _redDot() : SizedBox(),
            ],
          );
        });
  }

  Widget _redDot() {
    return Positioned(
      right: 12,
      top: 10,
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(7),
        ),
        constraints: BoxConstraints(
          minWidth: 12,
          minHeight: 12,
        ),
        child: Container(
          width: 1,
          height: 1,
        ),
      ),
    );
  }
}
