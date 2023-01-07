//Create update delete
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        if (kDebugMode) {
          print("Error ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error Catch $e");
      }
      rethrow;
    }
  }

  postRequest(String url, Map data) async {
    //await Future.delayed(Duration(seconds: 1));
    try {
      var response = await http
          .post(
        Uri.parse(url),
        body: data,
      )
          .timeout(
        const Duration(seconds: 5),
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        if (kDebugMode) {
          print("Error ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error Catch $e");
      }
      rethrow ;
    }
  }
}
