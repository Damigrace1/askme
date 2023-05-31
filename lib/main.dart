import 'package:chatgpt_app/chat/presentation/screens/chat_screen.dart';
import 'package:chatgpt_app/onboarding/presentation/screens/welcome_page.dart';
import 'package:chatgpt_app/utilities/connectivity.dart';
import 'package:chatgpt_app/utilities/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future  main() async{
  await dotenv.load(fileName: ".env");
  ConnectivityService();
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

          title: 'ChatGPT',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a blue toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
              colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff6C63FF)),
              useMaterial3: true,
              fontFamily: 'NotoSans'
          ),
          home:  const WelcomePage(),
        );
      },
    );
  }
}

