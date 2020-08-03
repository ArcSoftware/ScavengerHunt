import 'package:scavenger_hunt/Models/apilog_model.dart';

class AppConfig {
  String apiUrl;
  String apiKey;
  // String accessToken;
  Map<String, String> apiHeaders;
  String webUrl;
  String appVersion;
  String supportEmail;
  String deviceInfo;

  AppConfig() {   
    apiUrl = "";
    apiKey = "";
    apiHeaders = {
      "apiKey": apiKey, 
      "content-type": "application/json",
      "platform": "${getPlatformLogType()}"
    };
    webUrl = "";
    
    appVersion="v1.0.0";
    supportEmail = "dev.jaket@gmail.com";
  }

  void updateHeaders() { 
    int platform = getPlatformLogType();
    this.apiHeaders = {
      "apiKey": this.apiKey, 
      "content-type": "application/json",
      // "Authorization": "Bearer ${this.accessToken}", can use AAD later if desired
      "platform": "$platform"
    };
  }

  // Future<void> saveToCache(String key, dynamic value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //Type assessment can only be done inline unfortunately
  //   if (value is int) await prefs.setInt(key, value);
  //   if (value is bool) await prefs.setBool(key, value);
  //   if (value is String) await prefs.setString(key, value);
  //   if (value is double) await prefs.setDouble(key, value);
  // }

  // Future<dynamic> readFromCache(String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.get(key);
  // }
}