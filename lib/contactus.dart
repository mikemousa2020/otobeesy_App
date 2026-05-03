import 'package:flutter/material.dart';
import 'dart:convert';
import 'myDrawer.dart';
import 'callApi.dart';

class Contactus extends StatefulWidget {
  const Contactus({super.key});

  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  String result = '';
  //bool inSave = false;

  TextEditingController userNameController =      TextEditingController(text: user.userName );
  TextEditingController userEmailController =      TextEditingController(text: user.userEmail );
  TextEditingController userTelNoController =      TextEditingController(text: user.userTelNo );
  TextEditingController msgController = TextEditingController(text: ''
      //'test test test test test test test test test test test test test test test test test test test test test test test test test test test '
      );

  bool isShow = true;
bool isWaiting=true;
  @override
  Widget build(BuildContext context) {
    //userNameController.text='Test 2' ;
    return Scaffold(
      appBar: myAppBar('اتصل بنا'),
      endDrawer: MyDrawer(),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: <Widget>[
            const Text('نريد أن نسمع رأيك',
                style: TextStyle(fontSize: 22), textAlign: TextAlign.center),
            //SizedBox(height: 10),
            const Text(
              'حرصاً منا على تلبيه مطالبكم .. نهتم بالتواصل معكم شخصياً .. ويسعدنا ان ننال رضاكم واسعادكم على الدوام',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 5),
            const Text(
              'يسعدنا التواصل معكم واستقبال اقتراحتكم واستفساراتكم عن الحجز والشكاوى :',
              style: TextStyle(fontSize: 12),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 5),
            const Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Icon(Icons.phone),
                SizedBox(width: 10),
                Text('19934',
                    style: TextStyle(fontSize: 14), textAlign: TextAlign.right),
              ],
            ),
            Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                const Icon(Icons.mail),
                const SizedBox(width: 10),
                Text(companyID==10?'info@alasma.com':'info@goldenhorse-eg.com',
                    style: const TextStyle(fontSize: 14), textAlign: TextAlign.right),
              ],
            ),
            const SizedBox(height: 5),

            Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: userNameController,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      decoration: myInputDecoration('الاسم بالكامل', 10,5,10,15,5),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      controller: userEmailController,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: myInputDecoration('البريد الاكترونى', 10,5,10,15,5),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        controller: userTelNoController,
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        decoration: myInputDecoration('رقم التليفون', 10,5,10,15,5)),
                    const SizedBox(height: 10),
                    TextField(
                        maxLines: 4,
                        maxLength: 400,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.start,
                        controller: msgController,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: myInputDecoration('الرسالة', 10,5,10,15,5)),
                  ],
                )),
            //SizedBox(height: 5),

            isShow
                ? RawMaterialButton(
                    fillColor: Colors.red,
                    splashColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 100),
                    onPressed: () {
                      setState(() {
                        isShow = false;
                        result = '';
                      });
                      contactusSave(
                              userNameController.text,
                              userEmailController.text,
                              userTelNoController.text,
                              msgController.text)
                          .then((response) {
                        var r = json.decode(response.body);
                        setState(() {
                          result = r; // r['Result'];
                          if (result == "") isWaiting = false;
                          isShow = result != "";
                        });
                      });
                    },
                    shape: const StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('ارسال الرسالة',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ],
                    ),
                  )
                : isWaiting ? wait() : const Center(child:Text('تم تلقى طلبكم وسيتم التواصل معكم فى اقرب وقت') ,) ,
            //SizedBox(height: 5),
            Text(
              result,
              style: const TextStyle(color: Colors.blue, fontSize: 15),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
