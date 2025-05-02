import 'dart:convert';
import 'dart:math';
import 'package:chatgpt_app/main.dart';
import 'package:hive/hive.dart';

const baseUrl = 'https://ask-me-8eih.onrender.com/';





Future<Box?> getTexts()async{
  return prompts;
}

Future<void> saveText(String text) async {
  prompts?.put(Random().nextInt(100),text);
}

Future<void> deleteOne(int key) async {
  prompts?.delete(key);
}
// Future<void> saveText(String text) async {
//   final url = Uri.tryParse('${baseUrl}updateText');
//   final headers = {'Content-Type': 'application/json'};
//   final body = jsonEncode({
//     "userId" : uId,
//     "text" : text
//   });
//   final response = await http.post(url!, headers: headers,body:body);
//   final res = jsonDecode(response.body);
//   print(res);
//   return res;
//
// }

// Future<List> getTexts() async {
//   final url = Uri.tryParse('${baseUrl}getTexts');
//   final headers = {'Content-Type': 'application/json'};
//   final body = jsonEncode({"userId" : uId});
//   final response = await http.post(url!, headers: headers,body:body);
//   final res = jsonDecode(response.body);
//
//  print(res["result"].runtimeType);
//   return res["result"];
// }
// Future<dynamic> saveUser(String id) async {
//
//   final url = Uri.tryParse('${baseUrl}saveUser');
//   final headers = {'Content-Type': 'application/json'};
//   final body = jsonEncode({"userId" : id});
//   final response = await http.post(url!, headers: headers,body:body);
//   final res = jsonDecode(response.body);
//   print(res["texts"]);
//   return res["texts"];
//
// }
// Future<Map<String, dynamic>> deleteOne(String tId) async {
//   final url = Uri.tryParse('${baseUrl}deleteOne');
//   final headers = {'Content-Type': 'application/json'};
//   final body = jsonEncode({
//     "userId" : uId,
//     "textId" : tId
//   });
//   final response = await http.post(url!, headers: headers,body:body);
//   final res = jsonDecode(response.body);
//   return res;
// }
//
// Future<List> deleteAll() async {
//   final url = Uri.tryParse('${baseUrl}deleteAll');
//   final headers = {'Content-Type': 'application/json'};
//   final body = jsonEncode({
//     "userId" : uId,
//   });
//   final response = await http.post(url!, headers: headers,body:body);
//   final res = jsonDecode(response.body);
//
// //  print(res["result"].runtimeType);
//   return res;
// }