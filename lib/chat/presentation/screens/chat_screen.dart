import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt_app/chat/presentation/widgets.dart';
import 'package:chatgpt_app/utilities/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shimmer/shimmer.dart';

import '../../application/services.dart';
import '../../domain/model.dart';
import '../controllers.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  void chatComplete() async {

    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": lastQuery})
    ],
        stream: true,
        maxToken: 3000, model: ChatModel.gptTurbo0301);
    MessageModel md = MessageModel(message: '', isAI: true);
    List<String>  tokens =[];
    messages.add(
        md);
  chatGPT?.onChatCompletionSSE(request: request,onCancel: stopGen).listen((event) {
    tokens.add(event.choices.last.message!.content);
    md.message = tokens.join();
    setState(() {
      scrollController!.animateTo(
          scrollController!.position.maxScrollExtent + 1000
          , duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn);
    });
    }).onDone(() {
      setState(() {
        aiAns = true;
        isLoading = false;
      });
  });

  }
  CancelData? cancelD;
  void handleSubmitted(String text) {
    //makePostRequest();
    {
      isLoading = true;
      aiAns = false;
      setState(() {
        scrollController!.animateTo(
            scrollController!.position.maxScrollExtent
                + 1000
            , duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn);
      });
      messages.add(MessageModel(message: text, isAI: false));
      try{
        chatComplete();
      }
      catch(e){
        print('There is an issue');
      }

    }
    textController.clear();
  }
void stopGen(CancelData cancelData){
    cancelD = cancelData;
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     chatGPT = OpenAI.instance.build(
        token: dotenv.env["api_key"],
        baseOption: HttpSetup(receiveTimeout:
        const Duration(seconds: 60)),enableLog: true);
    Future.delayed(Duration.zero, () {
      focusNode.requestFocus();
    });

  }
  Future<bool> exit() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you really want to leave?'),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No'),
          ),

          ElevatedButton(
            onPressed: (){ Navigator.of(context).pop(true);
            notify = false;
            },
            //return true when click on "Yes"
            child:Text('Yes'),

          ),

        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat ',style: TextStyle(fontWeight: FontWeight.bold),),
          actions: [
            IconButton(onPressed: (){
           setState(() {
             messages.clear();
             messages.add(
                 MessageModel(message:'Hi 😉, what will you like to ask?', isAI: true)
             );
             aiAns = false;
           });
            }, icon:
            Icon(Icons.delete))
          ],
        ),
        body: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                reverse: false, // to show the latest messages at the bottom
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onLongPress: (){
                      messages[index].isAI ? {
                      Clipboard.setData(ClipboardData(text:
                      messages[index].message)),
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You have copied this response.')),
                      )
                      }:{};
                    },
                    onDoubleTap: (){
                      messages[index].isAI ? {
                        Clipboard.setData(ClipboardData(text:
                        messages[index].message)),
                        ScaffoldMessenger.of(context).showSnackBar(

                          const SnackBar(
                              content: Text('You have copied this response.'),
                            backgroundColor: Colors.deepPurple,
                          ),
                        )
                      }:{};
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal:
                      10,vertical: 15),
                      decoration: BoxDecoration(
                        color: messages[index].isAI ? Color(0xffF7F7F8):
                        Colors.white,
                        border: Border.all(color: Color(0xffDEDEDF))
                      ),
                        child:
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          messages[index].isAI ? Image.asset(
                              'lib/assets/images/_icon.png',width: 38.w,height: 38.h,):
                          Container(
                            width: 38.w,height: 38.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child:  Text(
                                  'Me',
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                      color: Colors.white
                                    )
                                ),
                              ),
                          SizedBox(width: 20.w,),
                          Flexible(
                            child: Text(messages[index].
                            message,
                              softWrap: true,
                              style: TextStyle(
                              fontSize: 15.sp,
                            ),),
                          ),
                        ],
                      )
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.h,),
            if(isLoading)
              InkWell(
                onTap: (){
                  isLoading = false;
                  aiAns = true;
                  setState(() {

                  });
                  try{
                    cancelD?.cancelToken.cancel('canceled');
                  }
                  catch(e){
                    print('There is an issue');
                  }
                },
                child: Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 15.0,
                      vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                    border: Border.all(color: Color(0xffDEDEDF),width: 2),
                  ),
                  child: Text('Stop',style: TextStyle(
                      fontSize: 17.sp,color: Colors.grey
                  ),),
                ),
              ),
            SizedBox(height: 15.h),
            if(aiAns)
              InkWell(
                onTap: (){
                  isLoading = true;
                  aiAns = false;
                  setState(() {
                    scrollController!.animateTo(
                        scrollController!.position.maxScrollExtent
                            + 1000
                        , duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn);
                  });
                  try{
                    chatComplete();
                  }
                  catch(e){
                    print('There is an issue');
                  }
                },
                child: Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 15.0,
                  vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                    border: Border.all(color: Color(0xffDEDEDF),width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh,color: Colors.grey,
                      size: 25.sp,),
                      SizedBox(width: 10.w,),
                      Text('Not Satisfied? I can rephrase',style: TextStyle(
                        fontSize: 17.sp,color: Colors.grey
                      ),)
                    ],
                  ),
                ),
              ),
            SizedBox(height: 15.h),
            sendButton(),
            SizedBox(height: 10,)
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //       ' Developed by Whitedeveloper. ',style:
            //     TextStyle(color: Color(0xffD2D2D9) ),),
            // )
          ],
        ),
      ),
    );
  }

  Widget sendButton() {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(color: Color(0xffDEDEDF),width: 2),
      ),
      child: Row(
        children: [
          SizedBox(width: 10.w,),
          Flexible(
            child: TextField(
              focusNode: focusNode,
              textCapitalization: TextCapitalization.sentences,
              controller: textController,
              textInputAction: TextInputAction.send,
              onSubmitted: (val){
                if(textController.text.isNotEmpty){

                  aiAns = false;
                  FocusScope.of(context).unfocus();
                  lastQuery = textController.text;
                  handleSubmitted(lastQuery);}
              },
              decoration: InputDecoration.collapsed(
                hintText: ' Type your question',
              ),
            ),

          ),
          IconButton(
            icon : Image.asset('lib/assets/images/send_icon.png',
                width: 27.w,height: 27.h,
                color: const Color(0xffDEDEDF)
            ),
            onPressed: () {
              if(textController.text.isNotEmpty){
                aiAns = false;
                FocusScope.of(context).unfocus();
                lastQuery = textController.text;
                handleSubmitted(lastQuery);}
            },
          ),
        ],
      ),
    );
  }
}


