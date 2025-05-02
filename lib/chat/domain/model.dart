
final List<MessageModel> messages = [
  MessageModel(message:'Hi 😀, what would you like to ask?', isAI: true)
];
String lastQuery = '';
bool isLoading = false;
bool netAvail = false;
bool isNew = true;
bool aiAns = false;
bool notify = false;
class MessageModel{
  String message;
  bool isAI;

  MessageModel({required this.message, required this.isAI});
}