import 'dart:convert';
import 'package:flutter/material.dart';
import 'callApi.dart';

class SignUp extends StatefulWidget {
  final faceData;
  const SignUp(this.faceData, {super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _addUserResult = '',
      socialID = '',
      userName = '',
      userEmail = '',
      userTelNo = '',
      userPassword = '',
      picUrl = '';
  bool _load = false;
//Future signup(String socialID, String userName, String userEmail,    String userTelNo, String userPassword, String picUrl) {
  _signup() {
    setState(() {
      _load = true;
    });

    signup(socialID, userNameController.text, userEmailController.text,
            userTelController.text, userPasswordController.text, picUrl)
        .then((response) {
      var u = json.decode(response.body);
      if (u != null) {
        if (u['UserID'] > 0 && u['Result'] == '') {
          _addUserResult = 'تم التسجيل';

          user.userToken = u['UserToken'] ?? '';
          user.userID = u['UserID'];
          user.userPassword = userPasswordController.text;
          user.userIsFace = socialID != '';
          user.usersocialID = socialID;
          user.userPicUrl = picUrl;
          user.userEmail = u['UserEmail'] ?? '';
          user.userName = u['UserName'] ?? '';
          user.userTelNo = u['UserTelNo'] ?? '';
          //user.userPassword = u['UserPassword'] ?? '';
          //faceResult =              '${user.userEmail},${user.userPassword},${user.userIsFace},${user.userID}';

          String faceResult =
              '${user.userEmail},${user.userPassword},${user.userID},${user.userIsFace},${user.usersocialID}';

          writeData(faceResult);

          Navigator.of(context).pop();
          Navigator.of(context).pop();
          //Navigator.of(context).pop();

          //Navigator.push(context,new MaterialPageRoute(builder: (context) => new Login()));
          //Navigator.pop()

        } else {
          _addUserResult = u['Result'];
          _load = false;
        }
      }

      setState(() {});
    });
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userTelController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  @override
  initState() {
    if (widget.faceData != null) {
      socialID = widget.faceData['id'];
      userName = widget.faceData['name'];
      userEmail = widget.faceData['email'];

      userNameController.text = userName;
      userEmailController.text = userEmail;

      //picUrl=widget.faceData['picture']['url'];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(),
        body: Center(
      child: Container(
        //color: Colors.red,
        height: 550,
        padding: const EdgeInsets.all(20),
        child: ListView(
          //textDirection: TextDirection.rtl,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            logo(),
            const SizedBox(height: 10),
            const Text('اشترك الآن في حساب جديد',
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            TextField(
              controller: userNameController,
              //onChanged: onChangeEmail,
              //textDirection: TextDirection.rtl,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'الاسم بالكامل',
                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: userEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  myInputDecoration('البريد الالكترونى', 32, 20, 10, 20, 10),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: userTelController,
              keyboardType: TextInputType.emailAddress,
              decoration: myInputDecoration('رقم التليفون', 32, 20, 10, 20, 10),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: userPasswordController,
              obscureText: true,
              decoration: myInputDecoration('كلمة السر', 32, 20, 10, 20, 10),
            ),
            const SizedBox(height: 30),
            _load
                ? const Center(child: CircularProgressIndicator())
                : RawMaterialButton(
                    fillColor: Colors.red,
                    splashColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 100),
                    onPressed: () {
                      _signup();
                    },
                    shape: const StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('اشترك الان',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ],
                    ),
                  ),
            Text(
              _addUserResult,
              style: const TextStyle(color: Colors.red, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ));
  }
}
