import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<void> initFCM() async {
    // Minta izin notifikasi
    await _fcm.requestPermission();

    // Dapatkan token FCM
    String? token = await _fcm.getToken();
    print('🔥 FCM Token: $token');

    if (token != null) {
      await saveTokenToServer(token);
    }

    // Listener kalau token berubah
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('🔁 Token diperbarui: $newToken');
      saveTokenToServer(newToken);
    });
  }

  static Future<void> saveTokenToServer(String token) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.5:8000/api/save-fcm-token'),
      body: {
        'user_id': '1',
        'token': token,
      },
    );
    print('📡 Response dari server: ${response.body}');
  }
}
