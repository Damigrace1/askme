import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application/functions.dart';
import '../../domain/controllers/chatController.dart';
import '../../domain/model.dart';
import '../controllers.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
    child: ListView.builder(
    controller: scrollController,
reverse: false, // to show the latest messages at the bottom
itemCount: messages.length,
itemBuilder: (BuildContext context, int index) {
return InkWell(
splashColor: Colors.transparent,
onLongPress: () {
Clipboard.setData(ClipboardData(text: messages[index].message));
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('You have copied this response.'),
backgroundColor: Colors.deepPurple,
),
);
},
onDoubleTap: () {
Clipboard.setData(ClipboardData(text: messages[index].message));
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('You have copied this response.'),
backgroundColor: Colors.deepPurple,
),
);
},
child: Container(
margin: EdgeInsets.only(
bottom: 10,
right: messages[index].isAI ? 50 : 6,
left: !messages[index].isAI ? 50 : 6),
padding:
const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
decoration: BoxDecoration(
color: messages[index].isAI
? Colors.blue.withOpacity(0.5)
    : Colors.purple.withOpacity(0.5),
// messages[index].isAI ? Color(0xffF7F7F8):
// Colors.white,
borderRadius: BorderRadius.circular(8)
// border: Border(
//     left: BorderSide(color: Color(0xffDEDEDF)),
//     right: BorderSide(color: Color(0xffDEDEDF)),
//     bottom: BorderSide(color: Color(0xffDEDEDF)),
//     top: BorderSide(color: Color(0xffDEDEDF)))
),
child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
if (messages[index].isAI)
messages[index].isAI
? Image.asset(
'lib/assets/images/_icon.png',
width: 38.w,
height: 38.h,
)
    : Container(
width: 38.w,
height: 38.h,
alignment: Alignment.center,
decoration: BoxDecoration(
color: Colors.deepPurple,
borderRadius: BorderRadius.circular(8)),
child: Text('Me',
style: TextStyle(
fontSize: 20.sp, color: Colors.white)),
),
SizedBox(
width: 10.w,
),
Expanded(
child: Align(
child: Text(
messages[index].message,
softWrap: true,
style:
TextStyle(fontSize: 15.sp, color: Colors.white),
),
alignment: !messages[index].isAI
? Alignment.centerRight
    : Alignment.centerLeft,
),
),
if (!isLoading && messages[index].isAI)
Align(
alignment: Alignment.centerRight,
child: InkWell(
splashColor: Colors.transparent,
onTap: () async {
ChatController.it.selectedIndex = index;
ChatController.it.isSpeaking
? ChatController.it.textToSpeech.pause()
    :read(messages[index].message);
},
child: Icon(
(ChatController.it.isSpeaking &&
ChatController.it.selectedIndex == index)
? CupertinoIcons.pause
    : CupertinoIcons.speaker,
color: Color(0xfff9ce80),
)),
),
SizedBox(
width: 10.w,
),
if (!messages[index].isAI)
messages[index].isAI
? Image.asset(
'lib/assets/images/_icon.png',
width: 38.w,
height: 38.h,
)
    : Container(
width: 38.w,
height: 38.h,
alignment: Alignment.center,
decoration: BoxDecoration(
color: Colors.deepPurple,
borderRadius: BorderRadius.circular(8)),
child: Text('Me',
style: TextStyle(
fontSize: 20.sp, color: Colors.white)),
),
],
)),
);
},
),
);
  }
}
