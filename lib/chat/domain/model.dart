import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

late OpenAI? chatGPT;
final List<MessageModel> messages = [
  MessageModel(message:'Hi 😉, what will you like to ask?', isAI: true)
];
String lastQuery = '';
bool isLoading = false;
bool aiAns = false;
bool notify = false;
class MessageModel{
  String message;
  bool isAI;

  MessageModel({required this.message, required this.isAI});
}