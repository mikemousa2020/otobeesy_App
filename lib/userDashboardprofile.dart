import 'dart:convert';
import 'package:flutter/material.dart';
import 'callApi.dart';
import 'myDrawer.dart';

class UserDashboardprofile extends StatefulWidget {
  const UserDashboardprofile({super.key});

  @override
  _UserDashboardprofileState createState() => _UserDashboardprofileState();
}

class _UserDashboardprofileState extends State<UserDashboardprofile> {
  String result = '';
  bool inSave = false;

  TextEditingController userNameController =
      TextEditingController(text: user.userName);
  TextEditingController userEmailController =
      TextEditingController(text: user.userEmail);
  TextEditingController userTelNoController =
      TextEditingController(text: user.userTelNo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: MyDrawer(),
        appBar: myAppBar('حسابى'),
        body: Center(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView(
                  children: <Widget>[
                    myPic(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('البيانات الشخصية',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 15),

                    TextField(
                        controller: userNameController,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: myInputDecoration('الاسم بالكامل')),

                    const SizedBox(height: 15),
                    TextField(
                        controller: userEmailController,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: myInputDecoration('البريد الالكترونى')),

                    const SizedBox(height: 15),
                    TextField(
                        controller: userTelNoController,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        decoration: myInputDecoration('رقم الموبيل')),
                    const SizedBox(height: 25),
                    inSave
                        ? wait()
                        : RawMaterialButton(
                            fillColor: Colors.red,
                            splashColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 100),
                            onPressed: () {
                              setState(() {
                                inSave = true;
                                result = '';
                              });
                              userProfileUpdate(
                                      userNameController.text,
                                      userEmailController.text,
                                      userTelNoController.text)
                                  .then((response) {
                                var r = json.decode(response.body);
                                setState(() {
                                  result = r['Result'];
                                  if (result == "") result = 'تم الحفظ بنجاح';
                                  inSave = false;
                                });
                              });
                            },
                            shape: const StadiumBorder(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('حفظ التعديلات',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      result,
                      style: const TextStyle(color: Colors.blue, fontSize: 15),
                      textAlign: TextAlign.center,
                    )
                    //Text('تم حفظ التعديلات',style: TextStyle(color: Colors.blue),textAlign: TextAlign.center,)
                  ],
                ),
              )),
        ));
  }
}
