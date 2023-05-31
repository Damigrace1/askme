import 'dart:convert';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:http/http.dart' as http;

import '../domain/model.dart';
import '../presentation/controllers.dart';

Future<void> makePostRequest() async {
  final url = Uri.tryParse('https://wedev-lwi8.onrender.com/api/test');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({"name" : "alabi"});
  print('jhgfd');
  final response = await http.post(url!, headers: headers, body: body);
  final res = jsonDecode(response.body);
  print(res["statusCode"]);
  // if (response.statusCode == 201) {
  //   print('Post request successful!');
  //   print('Response body: ${response.body}');
  // } else {
  //   print('Post request failed with status code ${response.statusCode}');
  // }
}
