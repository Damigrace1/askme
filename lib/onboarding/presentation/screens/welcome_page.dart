import 'package:chatgpt_app/chat/presentation/screens/chat_screen.dart';
import 'package:chatgpt_app/main.dart';
import 'package:chatgpt_app/onboarding/application/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../chat/domain/model.dart';
import '../../../utilities/keys.dart';



class WelcomePage extends StatefulWidget {
   WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController cont = TextEditingController();
  ScrollController controller = ScrollController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,

      body: ListView(
        reverse: true,
        shrinkWrap: true,
        children: [
          Stack(
            children: [
              Container(
                color: Color(0xff1C1567),
                height: MediaQuery.of(context).size.
                height,
                width: MediaQuery.of(context).size.
                width,
              ),
              Container(
                height: MediaQuery.of(context).size.
                height,
                width: double.infinity,
                child:   Image.asset('lib/assets/images/fr.png',

              ),),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 384.w,
                  height: MediaQuery.of(context).size.
                  height-385.h,

                  child:  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Ask Me',style:
                  GoogleFonts.abel (
                  fontWeight: FontWeight.bold,
                      fontSize: 65.sp,color:Color(0xffF9CE80), )),

                      SizedBox(height: 20.h,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Center(
                          child: TextField(
                            controller: cont,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter your unique ID (Phone number)',
                              hintStyle: TextStyle(
                                color: Colors.grey
                              )
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Container(
                        height: 50.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: loading ?  Colors.grey.shade500 :
                          Color(0xffF9CE80),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child:  InkWell(
                          onTap: loading? null :  ()async{
                            setState(() {
                              loading = true;
                            });

                            //TODO: transiting to using hive so as to improve speed. Free server, render takes time to wake.
                            //  texts = await saveUser(cont.text);
                            // SharedPreferences prefs =await SharedPreferences.getInstance();
                            user?.put('user', cont.text);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ChatScreen()),
                            );
                          },
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 30,),
                              Center(child: Text(
                                loading ? 'Connecting with Dag...' : 'Submit' ,
                                style:GoogleFonts.acme(
                                    fontSize: 16.sp,color:Colors.black
                                )
                                ,)),
                              loading ? SizedBox(
                                height: 30.h,
                                width: 30.h,
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.grey.shade400
                                  ),
                                ),
                              ) : SizedBox(
                                height: 30.h,
                                width: 30.h,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 50.h,),
                      Text('Whitedeveloper1@gmail.com',style: TextStyle(
                          color: Colors.grey
                      ),),
                      SizedBox(height: 10.h,)
                    ],
                  ) ,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
