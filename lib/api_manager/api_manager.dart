import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class ApiManager{

  Future<http.Response> makePostRequestWithClient({
    @required String url,
    @required String body,
    Map<String, String> headers,
    http.Client client,
  }) async {
    http.Client httpClient = client ?? http.Client();
    http.Response response = await httpClient.post(
      url,
      body: body,
      headers: headers,
    );
    httpClient.close();
    return response;
  }

  Future<http.Response> makePostRequest({
    @required String url,
    @required String body,
    Map<String, String> headers,
  }) async {
    return await makePostRequestWithClient(
      url: url,
      body: body,
      headers: headers,
    );
  }

final baseUrl = "https://fcm.googleapis.com/fcm/send";

Future<dynamic> sendNotification({String teacherDeviceId,String studentName,String downloadUrl}) async {
  String url = baseUrl;
  Map<String, dynamic> bodyMap = {
    "to": teacherDeviceId,
    "notification": {
      "title": studentName+" Sent you the assignment",
      "body": "Please download the document",
      "mutable_content": true,
      "sound": "Tri-tone"
    }};

  http.Response response =
  await makePostRequest(url:url,headers:{
    "content_type":"application/json",
    "Authorization":"key=AAAAeC6xfnQ:APA91bF0nsK9MDAOv7eLASg7GHxT2eL7Qxo7zoNujkK43cTUh1UVW4qjC5RCRrKFp2ulMlm2t-UyLDaiyM05cMzqlZ4IT3OjMgdqllTew_liPH81yhbYSBBP9_0uekyB54Y6Zm-ttPFf"
  },body:json.encode(bodyMap));
  if (response.statusCode == 200) {
    print("notification Sucessfully sent");
    return response.body;
  }
}


}