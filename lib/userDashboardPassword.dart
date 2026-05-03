import 'dart:convert';
import 'package:flutter/material.dart';
import 'callApi.dart';
import 'myDrawer.dart';

class UserDashboardPassword extends StatefulWidget {
  const UserDashboardPassword({super.key});

  @override
  _UserDashboardPasswordState createState() => _UserDashboardPasswordState();
}

class _UserDashboardPasswordState extends State<UserDashboardPassword> {
  String result = '';
  bool inSave = false;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: MyDrawer(),
        appBar: myAppBar('تغيير كلمة السر'),
        body: Center(
          child: Container(
            //color: Colors.red,
            height: 550,
            padding: const EdgeInsets.all(20),
            child: ListView(
              //textDirection: TextDirection.rtl,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.https, size: 70),
                const SizedBox(height: 30),
                TextField(
                  //textDirection: TextDirection.rtl,
                  //textAlign: TextAlign.center,
                  controller: oldPasswordController,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.account_circle),
                    labelText: 'كلمة السر القديمة',
                    hintText: 'كلمة السر القديمة',
                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  //textDirection: TextDirection.rtl,
                  //textAlign: TextAlign.center,
                  controller: newPasswordController,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.account_circle),
                    labelText: 'كلمة السر الجديدة',
                    hintText: 'كلمة السر الجديدة',
                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                ),
                const SizedBox(height: 40),

                inSave
                    ? wait()
                    : RawMaterialButton(
                        fillColor: Colors.red,
                        splashColor: Colors.orange,
                        padding:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 100),
                        onPressed: () {
                          setState(() {
                            inSave = true;
                            result = '';
                          });
                          userPasswordUpdate(oldPasswordController.text,
                                  newPasswordController.text)
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
                            Text('حفظ ',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                const SizedBox(height: 5),
                Text(
                  result,
                  style: const TextStyle(color: Colors.blue, fontSize: 15),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ));
  }
}
