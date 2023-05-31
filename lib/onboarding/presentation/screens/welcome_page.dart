import 'package:chatgpt_app/chat/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utilities/keys.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        key: mainKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/images/ill_icon.png'),
                  SizedBox(height: 25.h,),
                  Text('Ask Me',style: TextStyle(
                      color: Color(0xff6C63FF),
                      fontFamily: 'Poppins',
                    fontSize: 65.sp,
                    fontWeight: FontWeight.bold
                  ),),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'I am Dag, your AI pal. Feel free to ask me any question and I promise to answer you to the best of my ability.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),

            Column(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0,
                        vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Color(0xff6C63FF),
                    //  border: Border.all(color: Color(0xff6C63FF),width: 2),
                    ),
                    child:  Text('Okay, I\'m in',style: TextStyle(
                        fontSize: 20.sp,
                      color: Colors.white
                    ),),
                  ),
                ),
                SizedBox(height: 50.h,),
                Text('Whitedeveloper1@gmail.com',style: TextStyle(
                    color: Colors.grey
                ),),
                SizedBox(height: 10.h,),
              ],
            )
          ],
        ),
      )
    );
  }
}
