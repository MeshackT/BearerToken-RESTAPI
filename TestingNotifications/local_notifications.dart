import 'dart:async';
import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../ReusableCode.dart';

class LocalNotificationService {
  /*
  * get access
  * Pass the variable retrieved to the notification REST API
  */
  static Future<String> generateFCMAccessToken() async {
    try {
      /* get these details from the file you downloaded(generated)
          from firebase console
      */
      String type = "FILL_UP";
      String project_id = "FILL_UP";
      String private_key_id = "FILL_UP";
      String private_key = "FILL_UP";
      String client_email = "FILL_UP";
      String client_id = "FILL_UP";
      String auth_uri = "FILL_UP";
      String token_uri = "FILL_UP";
      String auth_provider_x509_cert_url = "FILL_UP";
      String client_x509_cert_url = "FILL_UP";
      String universe_domain = "FILL_UP";

      final credentials = ServiceAccountCredentials.fromJson({
        "type": type,
        "project_id": project_id,
        "private_key_id": private_key_id,
        "client_email": client_email,
        "private_key": private_key,
        "client_id": client_id,
        "auth_uri": auth_uri,
        "token_uri": token_uri,
        "auth_provider_x509_cert_url": auth_provider_x509_cert_url,
        "client_x509_cert_url": client_x509_cert_url,
        "universe_domain": universe_domain
      });

      List<String> scopes = [
        "https://www.googleapis.com/auth/firebase.messaging"
      ];

      final client = await obtainAccessCredentialsViaServiceAccount(
          credentials, scopes, http.Client());
      final accessToken = client;
      Timer.periodic(const Duration(minutes: 59), (timer) {
        accessToken.refreshToken;
      });
      return accessToken.accessToken.data;
    } catch (e) {
      Reuse.logger.i("THis is the error: $e");
    }
    return "";
  }

  /*
  * Get the access Token
  * send a notification for updates and things to teach
  * */
  static Future<void> sendNotificationToTopicAllToSee(String title,
      String description, String topicTOSubscribe, String accessToken) async {
    try {
      var notification = {
        "message": {
          "notification": {
            'title': title,
            'body': description,
          },
          'data': <String, String>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          "topic": topicTOSubscribe,
        }
      };

      // Send the notification
      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/REPLACE_WITH_PROJECT_NAME/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(notification),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
