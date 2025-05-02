import 'dart:convert';

import 'package:chatgpt_app/chat/domain/controllers/chatController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../application/functions.dart';
import '../../domain/model.dart';
import '../controllers.dart';

class SendButton extends StatelessWidget {
  const SendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.transparent,
        border: Border.all(color: Color(0xffDEDEDF), width: 0.4),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 10.w,
          ),
          Flexible(
            child: TextField(
              style: TextStyle(color: Colors.white),
              focusNode: focusNode,
              textCapitalization: TextCapitalization.sentences,
              controller: textController,
              textInputAction: TextInputAction.send,
              onSubmitted: (val) {
                if (textController.text.isNotEmpty) {
                  aiAns = false;
                  FocusScope.of(context).unfocus();
                  netAvail
                      ? {
                    handleSubmitted(),
                  }
                      : {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                      content:
                      Text('Please check your internet connection'),
                      backgroundColor: Colors.deepPurple,
                    ))
                  };
                }
              },
              decoration: InputDecoration.collapsed(
                hintStyle: TextStyle(color: Colors.grey),
                hintText: 'Hello',
              ),
            ),
          ),
          IconButton(
            icon: Image.asset('lib/assets/images/send_icon.png',
                width: 27.w, height: 27.h, color: Colors.grey),
            onPressed: () async{

              if (textController.text.isNotEmpty) {
                aiAns = false;
                FocusScope.of(context).unfocus();
                netAvail
                    ? {
                  handleSubmitted(),
                }
                    : {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                    content:
                    Text('Please check your internet connection'),
                    backgroundColor: Colors.deepPurple,
                  ))
                };
              }
            },
          ),
          InkWell(
            splashColor: Colors.transparent,
            child: Icon(
              CupertinoIcons.mic,
              color: Colors.grey,
              size: 27.w,
            ),
            onTap: () {
              record();
            },
          ),
        ],
      ),
    );
  }
}


