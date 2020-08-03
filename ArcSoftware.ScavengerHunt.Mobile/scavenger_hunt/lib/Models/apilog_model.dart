import 'dart:convert';
import 'dart:io';
import 'package:scavenger_hunt/app_config.dart';

String apiLogToJson(ApiLog data) => json.encode(data.toJson());

String lflAttemptBody(AppConfig config, Exception e) {
  var ret = new ApiLog(
    logType: 1,
    logSeverity: 2,
    platform: Platform.isIOS ? 3 : 4,
    platformDesc: "App Log Attempt Exception",
    appVersion: config.appVersion,
    userKey: 1,
    logMessage: e.toString()
  ).toJson();

  return json.encode(ret);
}

class ApiLog {
    int logType;
    int logSeverity;
    int platform;
    String platformDesc;
    String appVersion;
    int userKey;
    String logMessage;

    ApiLog({
        this.logType,
        this.logSeverity,
        this.platform,
        this.platformDesc,
        this.appVersion,
        this.userKey,
        this.logMessage,
    });

    Map<String, dynamic> toJson() => {
        "logType": logType,
        "logSeverity": logSeverity,
        "platform": platform,
        "platformDesc": platformDesc,
        "appVersion": appVersion,
        "userKey": userKey,
        "logMessage": logMessage,
    };

    ApiLog logException(int logSeverity, String function, String logMessage){
      return new ApiLog(
        logType: LogType.error.index,
        logSeverity: logSeverity,
        platform: getPlatformLogType(),
        platformDesc: "App Exception: " + function,
        appVersion: this.appVersion,
        userKey: this.userKey,
        logMessage: logMessage
      );
    }

    ApiLog logInfo(String logMessage){
      return new ApiLog(
        logType: LogType.info.index,
        logSeverity: LogSeverity.info.index,
        platform: getPlatformLogType(),
        platformDesc: "App Info",
        appVersion: this.appVersion,
        userKey: this.userKey,
        logMessage: logMessage
      );
    }

    ApiLog logAccountFunction(String logMessage){
      return new ApiLog(
        logType: LogType.error.index,
        logSeverity: LogSeverity.info.index,
        platform: getPlatformLogType(),
        platformDesc: "App Account Function",
        appVersion: this.appVersion,
        userKey: this.userKey,
        logMessage: logMessage
      );
    }

    ApiLog logSecurity(int logSeverity, String function, String logMessage){
      return new ApiLog(
        logType: LogType.security.index,
        logSeverity: logSeverity,
        platform: getPlatformLogType(),
        platformDesc: "App Exception: " + function,
        appVersion: this.appVersion,
        userKey: this.userKey,
        logMessage: logMessage
      );
    }    
}

enum LogSeverity {
  info,
  warning,
  critical
}

enum LogType {
  info,
  error,
  security
}

enum LogPlatform {
  sql,
  api,
  web,
  iOS,
  android
}

int getPlatformLogType() {
  return Platform.isIOS ? LogPlatform.iOS.index : LogPlatform.android.index;
}