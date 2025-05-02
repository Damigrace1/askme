import 'dart:async';

import 'package:chatgpt_app/chat/domain/controllers/chatController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../main.dart';
import '../../onboarding/application/services.dart';
import '../../utilities/keys.dart';
import '../domain/model.dart';
import '../presentation/component/chat_sheet.dart';
import '../presentation/controllers.dart';
import '../presentation/screens/chat_screen.dart';


  endChat(BuildContext context) {
    ChatController.it.timer!.cancel();
    ChatController.it.callTime.value = 0;
    ChatController.it.audioChatIsActive.value = false;
    speechToText.cancel();
    ChatController.it.textToSpeech.stop();
    if (ChatController.it.chatSheetShowing.value) {
      Navigator.pop(context);
    }
    ChatController.it.update();
  }

  void startTimer() {
    ChatController.it.timer = new Timer.periodic(const Duration(seconds: 1),
        (Timer timer) => ChatController.it.callTime.value++);
  }

  Future<bool> speechPermissionHandler(BuildContext context) async {
    var status = await Permission.speech.status;
    if (status.isGranted) {
      // Permission is already granted
      print('Speech recognition permission granted.');
    } else if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.m
      if (await Permission.speech.request().isGranted) {
        // Permission is granted.
        print('Speech recognition permission granted.');
      } else {
        // Permission is denied (again).
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Please enable speech recognition permission in settings.'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () {
                openAppSettings();
              },
            ),
          ),
        );
      }
    } else if (status.isPermanentlyDenied) {
      // The permission is permanently denied, take the user to the app settings.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Speech recognition permission is permanently denied, please enable it in settings.'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    }
    return status.isGranted;
  }

  void buildChatSheet(BuildContext context) async {
   // ChatController.it.update();
    if (!ChatController.it.audioChatIsActive.value) {
      startTimer();
      ChatController.it.audioChatIsActive.value= true;
      record();
    }
    await showModalBottomSheet(
        context: context,
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          topLeft: Radius.circular(12),
        )),
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
            maxChildSize: 0.9,
            initialChildSize: 0.6,
            minChildSize: 0.5,
            builder: (context, controller) => ChatSheet()));
    ChatController.it.update();
  }

  Future readAiResponse(String text) async {
    await ChatController.it.textToSpeech.speak(text.replaceAll('*', ''));
    ChatController.it.finalWord = '';
    if (ChatController.it.audioChatIsActive.value) {
      record();
    }
  }

  Future read(String text) async {
    ChatController.it.isSpeaking = true;
    ChatController.it.update();
    await ChatController.it.textToSpeech.speak(text.replaceAll('😀', ''));

    ChatController.it.isSpeaking = false;
    ChatController.it.update();
  }

  record() async {
    ChatController.it.finalWord = '';
    speachEnabled = await speechToText.initialize(onStatus: (status) {
      if (status == 'done' && ChatController.it.audioChatIsActive.value) {
        if (ChatController.it.finalWord != '') {
          thinkAndRespond(text: ChatController.it.finalWord);
        } else {
          endChat(mainKey.currentContext!);
        }
      } else if (status == 'done' &&
          !ChatController.it.audioChatIsActive.value &&
          ChatController.it.finalWord != '') {
        handleSubmitted(text: ChatController.it.finalWord);
      }
    });
    if (!speachEnabled) {
      speachEnabled = await speechPermissionHandler(Get.context!);
    } else {
      speechToText.listen(
          listenOptions: SpeechListenOptions(
            listenMode: ListenMode.dictation,
          ),
          listenFor: Duration(minutes: 1),
          onResult: (result) {
            ChatController.it.finalWord = result.recognizedWords;
          });
    }
  }

  Future<bool> exit() async {
    return await showDialog(
//show confirm dialogue
//the return value will be from "Yes" or "No" options
          context: Get.context!,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you really want to leave?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
//return false when click on "NO"
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  notify = false;
                },
//return true when click on "Yes"
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  void handleSubmitted({String? text}) async {
    lastQuery = text ?? textController.text;
    if (!prompts!.values.contains(lastQuery)) {
      saveText(lastQuery);
    }
    ;
    textController.clear();
    isLoading = true;
    aiAns = false;
    scrollController!.animateTo(
        scrollController!.position.maxScrollExtent + 1000,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn);
    messages.add(MessageModel(message: lastQuery, isAI: false));
    try {
      final prompt = lastQuery;
      String resp = '';
      bool firstResp = true;
      final content = Content.text(prompt);
      ChatController.it.chatStream =
          ChatController.it.chatSession.sendMessageStream(content).listen(
        (content) {
          resp += content.text ?? '';
          MessageModel md = MessageModel(message: resp, isAI: true);
          if (firstResp) {
            messages.add(md);
            firstResp = false;
            ChatController.it.update();
          } else {
            messages[messages.length - 1] = md;

            scrollController!.animateTo(
                scrollController!.position.maxScrollExtent + 1000,
                duration: Duration(seconds: 1),
                curve: Curves.easeIn);
            ChatController.it.update();
          }
        },
        onError: (e) {
          print(e);
          ScaffoldMessenger.of(mainKey.currentContext!).showSnackBar(SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ));
        },
      )..onDone(() {
              isLoading = false;
              ChatController.it.update();
            });
    } catch (e) {
      print('There is an issue');
    }
  }

  void thinkAndRespond({String? text}) async {
    lastQuery = text ?? textController.text;
    if (!prompts!.values.contains(lastQuery)) {
      saveText(lastQuery);
    }
    ;
    textController.clear();
    isLoading = true;
    aiAns = false;
    scrollController!.animateTo(
        scrollController!.position.maxScrollExtent + 1000,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn);
    messages.add(MessageModel(message: lastQuery, isAI: false));
    try {
      bool firstResp = true;
      final content = Content.text(lastQuery);

      isLoading = true;
      ChatController.it.update();
      ChatController.it.chatSession.sendMessage(content).then(
        (content) {
          isLoading = false;
          ChatController.it.update();
          MessageModel md =
              MessageModel(message: content.text ?? '', isAI: true);
          if (ChatController.it.audioChatIsActive.value) {
            readAiResponse(content.text ?? '');
          }
          if (firstResp) {
            messages.add(md);
            firstResp = false;
            ChatController.it.update();
          } else {
            messages[messages.length - 1] = md;
            scrollController!.animateTo(
                scrollController!.position.maxScrollExtent + 1000,
                duration: Duration(seconds: 1),
                curve: Curves.easeIn);
            ChatController.it.update();
          }
        },
        onError: (e) {
          print(e);
          ScaffoldMessenger.of(mainKey.currentContext!).showSnackBar(SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ));
        },
      );
    } catch (e) {
      print('There is an issue');
    }
  }

