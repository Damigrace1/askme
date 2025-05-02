import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../main.dart';
import '../../../onboarding/application/services.dart';
import '../../presentation/controllers.dart';
import '../model.dart';

class ChatController extends GetxController{
  static ChatController it=Get.find<ChatController>();

  var audioChatIsActive = false.obs;
  var chatSheetShowing = false.obs;
  FlutterTts textToSpeech = FlutterTts();
  Timer? timer;
  var callTime = 0.obs;
  // set setCallTime(int val){
  //   callTime.value = val;
  //   update();
  // }

  String finalWord = '';
  bool isSpeaking = false;
  int selectedIndex = 0;
  late GenerativeModel model;
  late ChatSession chatSession;
  bool isCalling = false;
  StreamSubscription<GenerateContentResponse>? chatStream;


}