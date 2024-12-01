import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<NotificationModel> notifications = [
    NotificationModel(
      title: 'Meeting Tomorrow',
      date: '2023-11-22',
      content: 'Don\'t forget about the important meeting tomorrow at 10 AM.',
    ),
    NotificationModel(
      title: 'New Message',
      date: '2023-11-21',
      content: 'You have a new message from John Doe.',
    ),
    NotificationModel(
      title: 'Reminder',
      date: '2023-11-20',
      content: 'Reminder: Complete the project tasks by the end of the week.',
    ),
    NotificationModel(
      title: 'Meeting Tomorrow',
      date: '2023-11-18',
      content: 'Don\'t forget about the important meeting tomorrow at 10 AM.',
    ),
    NotificationModel(
      title: 'New Message',
      date: '2023-11-11',
      content: 'You have a new message from John Doe.',
    ),
    NotificationModel(
      title: 'Reminder',
      date: '2023-11-10',
      content: 'Reminder: Complete the project tasks by the end of the week.',
    ),
    // Add more notifications as needed
  ];

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
              title: notifications[index].title,
              date: notifications[index].date,
              content: notifications[index].content,
              onDelete: () {
                // Handle delete action here
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
    return Card(
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
                    color: Colors.grey,
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