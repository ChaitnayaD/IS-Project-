import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class HttpService {
  static final _client = http.Client();

  static var _loginUrl = Uri.parse('http://10.0.2.2:5000/login');

  static var _registerUrl = Uri.parse('http://10.0.2.2:5000/register');

  static login(email, password, context) async {
    http.Response response = await _client.post(_loginUrl, body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      //print(jsonDecode(response.body));
      var json = jsonDecode(response.body);

      if (json['status'] == 'Login Sucessfully') {
        await EasyLoading.showSuccess(json['status']);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage(title: "Docus")));
      } else {
        EasyLoading.showError(json['status']);
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  static register(username, email, password, context) async {
    http.Response response = await _client.post(_registerUrl, body: {
      'username': username,
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['status'] == 'username already exist') {
        await EasyLoading.showError(json['status']);
      } else {
        await EasyLoading.showSuccess(json['status']);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage(title: "Temperature graphs")));
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }
}