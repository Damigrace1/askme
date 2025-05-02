import 'dart:async';
import 'dart:ffi';
import 'package:chatgpt_app/chat/domain/controllers/chatController.dart';
import 'package:chatgpt_app/chat/presentation/component/chat_body.dart';
import 'package:chatgpt_app/chat/presentation/component/send_button.dart';
import 'package:chatgpt_app/main.dart';
import 'package:chatgpt_app/secret.dart';
import 'package:chatgpt_app/utilities/keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../../../onboarding/application/services.dart';
import '../../application/functions.dart';
import '../../domain/model.dart';
import '../component/chat_sheet.dart';
import '../controllers.dart';
import 'drawer.dart';


class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ChatController.it.textToSpeech.awaitSpeakCompletion(true);
    ChatController.it. textToSpeech.setSpeechRate(0.45);
    ChatController.it. textToSpeech.setPitch(1.0);
    ChatController.it.model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
      ],
    );
    ChatController.it.chatSession = ChatController.it.model.startChat();
    Future.delayed(Duration.zero, () {
      focusNode.requestFocus();
    });

    Future.delayed(Duration(seconds: 1),(){
    });
  }
  final backG = DecorationImage(
      image: AssetImage('lib/assets/images/chat_bg.jpg'), fit: BoxFit.cover);



  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: ( controller) {
      return WillPopScope(
        key: mainKey,
        onWillPop: exit,
        child: Container(
          decoration: BoxDecoration(color: Color(0xff000b15)),
          child: Scaffold(
            drawer: NavDrawer(),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Color(0xfff9ce80)),
              backgroundColor: ChatController.it.audioChatIsActive.value ? Colors.green : Colors.transparent,
              title: InkWell(
                splashColor: Colors.transparent,
                onTap: (){
                  if(ChatController.it.audioChatIsActive.value){
                    buildChatSheet(context);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chat ',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(width: 25.w,),
                    if(ChatController.it.audioChatIsActive.value
                    && !ChatController.it.chatSheetShowing.value)
                      Obx(()=>Text(
                        "${(ChatController.it.callTime.value ~/ 60).toString().padLeft(2, '0')}:${(
                            ChatController.it.callTime.value % 60).
                        toString().padLeft(2, '0')}",
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                      )
                          )
                  ],
                ),
              ),
              actions: [
            if(!ChatController.it.audioChatIsActive.value &&
            messages.length > 2)
                IconButton(
                    onPressed: () {
                      setState(() {
                        messages.clear();
                        messages.add(MessageModel(
                            message: 'Hi 😀, what would you like to ask?',
                            isAI: true));
                        aiAns = false;
                      });
                    },
                    icon: Icon(
                      CupertinoIcons.clear,
                      color: Color(0xfff9ce80),
                    )),
                if(!ChatController.it.audioChatIsActive.value)
                IconButton(
                    onPressed: () async {
                      buildChatSheet(context);
                    },
                    icon: Icon(
                      Icons.multitrack_audio,
                      color: Color(0xfff9ce80),
                    )),
                if(
                ChatController.it.audioChatIsActive.value
                && !ChatController.it.chatSheetShowing.value)
                  IconButton(
                    splashColor: Colors.transparent,
                    onPressed: (){
                      endChat(context);
                    },
                    icon: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 20.r,
                        child: Icon(Icons.call,color: Colors.white,size: 18.sp,)),
                  ),
              ],
            ),
            body: Column(
              children: [
                ChatBody(),
                SizedBox(
                  height: 10.h,
                ),
                if (isLoading)
                  InkWell(
                    onTap: () {
                      ChatController.it.chatStream?.cancel();
                      isLoading = false;
                      aiAns = true;
                      setState(() {});
                    },
                    child: Container(
                      height: 40.h,
                      padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.transparent,
                        border: Border.all(color: Color(0xffDEDEDF), width: 2),
                      ),
                      child: Text(
                        'Stop',
                        style: TextStyle(fontSize: 17.sp, color: Colors.grey),
                      ),
                    ),
                  ),
                SizedBox(height: 15.h),
                if (aiAns)
                  InkWell(
                    onTap: () {
                      isLoading = true;
                      aiAns = false;
                      setState(() {
                        scrollController!.animateTo(
                            scrollController!.position.maxScrollExtent + 1000,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn);
                      });
                      try {
                        handleSubmitted(text: lastQuery);
                      } catch (e) {
                        print('There is an issue');
                      }
                    },
                    child: Container(
                      height: 40.h,
                      padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.transparent,
                        border: Border.all(color: Color(0xffDEDEDF), width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 25.sp,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'Regenerate',
                            style:
                            TextStyle(fontSize: 17.sp, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 15.h),
                if(!ChatController.it.isCalling)
                 SendButton(),
                SizedBox(
                  height: 10,
                )
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //       ' Developed by Whitedeveloper. ',style:
                //     TextStyle(color: Color(0xffD2D2D9) ),),
                // )
              ],
            ),
          ),
        ),
      );
    },);
  }
}

