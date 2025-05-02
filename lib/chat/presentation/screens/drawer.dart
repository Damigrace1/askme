
import 'package:chatgpt_app/chat/presentation/controllers.dart';
import 'package:chatgpt_app/main.dart';
import 'package:chatgpt_app/onboarding/application/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:shimmer/shimmer.dart';

import 'chat_screen.dart';

class NavDrawer extends StatefulWidget {
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: Colors.black,
      width: 250.w,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h,),
              ListTile(
                visualDensity: VisualDensity(vertical: 0),
                minLeadingWidth: 0,
                title:
                Text('Previous Questions',style: TextStyle(color:
                Colors.white,fontSize: 18.sp,),
              ),
              subtitle:
              (prompts != null && prompts!.keys.length > 2 )?
              TextButton(
                onPressed: (){
                  prompts?.deleteAll(prompts!.keys);
                  setState(() {

                  });
                },
                child: Text('Clear All'
                ),
              ): null,),
              //texts.isEmpty ?
              FutureBuilder <Box?>(
                future: getTexts(),
                builder: (
                    BuildContext context, AsyncSnapshot snapshot)
                {

                  if(snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData){
                   Box data = snapshot.data;
                    if(data.values.isEmpty){
                      return
                        ListTile(
                          visualDensity: VisualDensity(vertical: 0),
                          leading:
                          Text('No saved prompts.',style: TextStyle(color:
                          Colors.grey,fontSize: 18.sp,),
                          ),);
                    }
                    else{
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.values.length,
                        itemBuilder: (context, index){
                        return ListTile(
                          onTap: (){
                            Navigator.pop(context);
                            textController.text = data.values.toList()[index];
                          },
                          leading: Icon(Icons.messenger_outline,
                          color: Colors.white,),
                          title: Text(data.values.toList()[index]??'',
                            maxLines: 2,
                            style:TextStyle(color: Colors.white,fontSize: 16.sp) ,
                            overflow: TextOverflow.ellipsis,),
                          trailing: IconButton(
                            icon: Icon(Icons.clear,
                            color: Color(0xfff9ce80),),
                            onPressed: () {
                              deleteOne(data.keys.toList()[index]);
                              setState(() {
                              });
                            },
                          ),
                        );
                        });}
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w
                    ),
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey,
                        child: Column(
                          children: [
                            ShimmerWidget(),
                            ShimmerWidget(),
                            ShimmerWidget()
                          ],
                        )
                    ),
                  );
                },)
              // ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: texts.length,
              //     itemBuilder: (context, index){
              //       print(texts);
              //       return ListTile(
              //         onTap: (){
              //           Navigator.pop(context);
              //           textController.text = texts[index]["message"];
              //         },
              //         leading: Icon(Icons.messenger_outline),
              //         title: Text(texts[index]["message"],
              //             style:TextStyle(color: Colors.white) ,
              //         overflow: TextOverflow.fade,),
              //         trailing: IconButton(
              //           icon: Icon(Icons.delete_outline),
              //           onPressed: () {  },
              //
              //         ),
              //       );
              //     })
            ],
          ),
        ),
      )
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white12,
          height: 8.h,
          width: 40.w,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          color: Colors.white12,
          height: 8.h,
          width: 150.w,
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}