import 'dart:convert';

import 'package:http/http.dart';

RetException exceptionFromJson(String str) => RetException.fromJson(json.decode(str));

String exceptionToString(Exception e) {
  var ret = e.toString();
  return ret[0] != "<" ? ret : "Message was HTML.";
}

void validatePostSuccess(Response r) {
  validateOkResponse(null, r, r.body);
}

void validateGetRequest(Response r) {
  if (r.statusCode == 404 && r.body != null) return; //No data found
  validateOkResponse(null, r, r.body);
}

void validateContainsData(Response r) { //For improved readability
  validateOkResponse(null, r, r.body);
}

void validateOkResponse(String method, BaseResponse b, String body) {
  if (b.statusCode == 200) return;

  var rBody = body != null ? body.toString() : "Response Body was Null.";
  throw new Exception("${method??'Method'} returned ${b.statusCode} - " + ((rBody[0] != "<") ? rBody : "Message was HTML."));
}

class RetException {
    String className;
    String message;
    dynamic data;
    dynamic innerException;
    dynamic helpUrl;
    String stackTraceString;
    dynamic remoteStackTraceString;
    int remoteStackIndex;
    dynamic exceptionMethod;
    int hResult;
    String source;
    dynamic watsonBuckets;

    RetException({
        this.className,
        this.message,
        this.data,
        this.innerException,
        this.helpUrl,
        this.stackTraceString,
        this.remoteStackTraceString,
        this.remoteStackIndex,
        this.exceptionMethod,
        this.hResult,
        this.source,
        this.watsonBuckets,
    });

    factory RetException.fromJson(Map<String, dynamic> json) => RetException(
        className: json["ClassName"],
        message: json["Message"],
        data: json["Data"],
        innerException: json["InnerException"],
        helpUrl: json["HelpURL"],
        stackTraceString: json["StackTraceString"],
        remoteStackTraceString: json["RemoteStackTraceString"],
        remoteStackIndex: json["RemoteStackIndex"],
        exceptionMethod: json["ExceptionMethod"],
        hResult: json["HResult"],
        source: json["Source"],
        watsonBuckets: json["WatsonBuckets"],
    );
}

enum PermissionType {
  location,
  camera
}