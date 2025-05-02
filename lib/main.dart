import 'package:chatgpt_app/chat/domain/controllers/chatController.dart';
import 'package:chatgpt_app/chat/presentation/screens/chat_screen.dart';
import 'package:chatgpt_app/onboarding/presentation/screens/welcome_page.dart';
import 'package:chatgpt_app/utilities/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'chat/domain/model.dart';
String? uId;
Box? user;
Box? prompts;
bool speachEnabled = false;
SpeechToText speechToText = SpeechToText();
Future  main() async{
  await Hive.initFlutter();
 // SharedPreferences prefs =await SharedPreferences.getInstance();
  // if(prefs.getBool('isNew' ) == false){
  //   isNew = false;
  //   uId = prefs.getString("uId");
  // }
  ChatController c=  Get.put(ChatController());
  user = await Hive.openBox('userBox');
  prompts = await Hive.openBox('promptBox');
  if(user?.get('user') != null){
    isNew = false;
    uId = user?.get("user");
  }
  ConnectivityService();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
    systemNavigationBarColor:
    Colors.black, // Set the systemNavigation bar color to transparent
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(384,805.3),
      minTextAdapt: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(

          debugShowCheckedModeBanner: false,
          title: 'ChatGPT',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.transparent,
              colorScheme: ColorScheme.fromSeed(seedColor: Color(0xfff9ce80)),
              useMaterial3: true,
              fontFamily: 'NotoSans'
          ),
          home: isNew ?  WelcomePage() : ChatScreen(),
        );
      },
    );
  }
}

