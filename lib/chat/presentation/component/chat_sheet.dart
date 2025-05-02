
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../application/functions.dart';
import '../../domain/controllers/chatController.dart';
import '../screens/chat_screen.dart';

class ChatSheet extends StatefulWidget {
  const ChatSheet({Key? key}) : super(key: key);

  static List<Color> _colors = [
    Colors.teal.withOpacity(0.2),
    Color(0xfff9ce80).withOpacity(0.2),
    Colors.blueAccent.withOpacity(0.2)
  ];

  static const _durations = [
    5000,
    4500,
    4000,
  ];

  static const _heightPercentages = [
    0.66,
    0.67,
    0.68,
  ];

  @override
  State<ChatSheet> createState() => _ChatSheetState();
}

class _ChatSheetState extends State<ChatSheet> {
  @override
  void initState() {
    // TODO: implement initState
    ChatController.it.chatSheetShowing.value = true;
    super.initState();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    ChatController.it. chatSheetShowing.value = false;
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {

    return  Container(
      width: 384.w,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(CupertinoIcons.clear)),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: (){
              endChat(context);
            },
            child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 35.r,
                child: Icon(Icons.call,color: Colors.white,size: 38.sp,)),
          ),
          SizedBox(height: 12.h,),
          Text('Audio Chat Ongoing...',style: TextStyle(color: Colors.white),),
          SizedBox(height: 6.h,),
          Obx(()=>
              Text(
                "${(ChatController.it.callTime.value ~/ 60).toString().padLeft(2, '0')}:${(
                    ChatController.it.callTime.value% 60).
                toString().padLeft(2, '0')}",
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,
                    fontSize: 28.sp),
              )),
          Expanded(
            child: WaveWidget(
              config: CustomConfig(
                colors: ChatSheet._colors,
                durations: ChatSheet._durations,
                heightPercentages: ChatSheet._heightPercentages,
              ),
              backgroundColor: Colors.transparent,
              size: Size(double.infinity, double.infinity),
            ),
          ),
        ],),
    );
  }
}