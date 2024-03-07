import 'package:creche/TestingNotifications/local_notifications.dart';
import 'package:flutter/material.dart';

import '../ReusableCode.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController about = TextEditingController();
    TextEditingController message = TextEditingController();

    String sentToThese = "allToSee";

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TODO your text filled here
            // TextFormField(...)
            // TextFormField(...)

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  /*
                  * Add these packages
                  *
                  * firebase_messaging
                  * firebase_core
                  * http
                  * googleapis_auth: ^1.4.1
                  * logger (not necessary)
                  */

                  // call the bearer method
                  String token =
                      await LocalNotificationService.generateFCMAccessToken();

                  // pass the bearer token to the REST API
                  // Here we are calling the notification
                  Future.delayed(
                    const Duration(milliseconds: 300),
                    () => LocalNotificationService
                            .sendNotificationToTopicAllToSee(
                                about.text, message.text, sentToThese, token)
                        .whenComplete(
                      () => Reuse.logger.e(" sent"), //import the package logger
                    ),
                  );
                },
                child: const Text("Send Notification"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
