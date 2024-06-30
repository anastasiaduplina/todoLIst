import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const String baseUrl = "https://hive.mrdekk.ru/todo";
  static const String baseUrlList = "https://hive.mrdekk.ru/todo/list";
  static const String token = "Uinen";
  static const String headerRevision = "X-Last-Known-Revision";
  static Future<bool> setRevision(int revision) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt('revision', revision);
  }

  static Future<int> getRevision() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('revision') ?? 0;
  }
}
