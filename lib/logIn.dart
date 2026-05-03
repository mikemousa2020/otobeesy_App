import 'package:flutter/material.dart';
import 'callApi.dart';
import 'forgetPassword.dart';
import 'signUp.dart';
import 'dart:convert';
//import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  //final Function() _userLogIn;
  //LogIn({Key key, @required this.userLogIn}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _load = false;
  String _userEmail = '';
  String _userPassword = '';
  String _loginResult = '';
  final String _usersocialID = '';
  // String userIsFace = '0';

  void onChangeEmail(String value) {
    setState(() {
      //return 
      _userEmail = value;
    });
  }

  void onChangePassword(String value) {
    setState(() {
      //return 
      _userPassword = value;
    });
  }

  _userLogIn(bool byFacebook, faceData) {
    user.userID = 0;
    //user.usersocialID = '';
    user.userToken = '';
    user.userPicUrl = '';
    String tempEmail = _userEmail;
    String tempsocialID = _usersocialID;

    if (byFacebook) {
      tempEmail = '';
    } else {
      tempsocialID = '';
    }

    setState(() {
      _load = true;
    });
    login(tempsocialID, tempEmail, _userPassword).then((response) {
      var u = json.decode(response.body);
      //print(user);
      setState(() {
        _load = false;
        if (u != null && u['UserID'] != null && u['UserID'] > 0) {
          user.userToken = u['UserToken'] ?? '';
          user.userID = u['UserID'];
          user.userPassword = _userPassword;
          user.userIsFace = _usersocialID != '';
          user.usersocialID = _usersocialID;
          user.userPicUrl = u['Pic_Url'] ?? '';
          user.userEmail = u['UserEmail'] ?? '';
          user.userName = u['UserName'] ?? '';
          user.userTelNo = u['UserTelNo'] ?? '';
          //user.userPassword = u['UserPassword'] ?? '';
          //faceResult =              '${user.userEmail},${user.userPassword},${user.userIsFace},${user.userID}';

          faceResult =
              '${user.userEmail},${user.userPassword},${user.userID},${user.userIsFace},${user.usersocialID}';

          writeData(faceResult);

          //Navigator.pop(context,new MaterialPageRoute(builder: (context) => LogIn()));
          Navigator.pop(context, true);
        } else {
          if (byFacebook) {
            goTo(context, SignUp(faceData));
          }
        }
        _loginResult = u['Result'] ?? '';
      });
    });
  }

  String faceResult = '';

  // Future<String> _face() async {
  //   var facebookLogin = new FacebookLogin();
  //   var result = await facebookLogin
  //       .logInWithReadPermissions(['email', 'public_profile']);
  //   String s = '';
  //   print(result);

  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       //_sendTokenToServer(result.accessToken.token);
  //       //_showLoggedInUI();
  //       s = result.accessToken.userId;
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       //_showCancelledMessage();
  //       break;

  //     case FacebookLoginStatus.error:
  //       //_showErrorOnUI(result.errorMessage);
  //       s = result.errorMessage;
  //       break;
  //   }
  //   setState(() {
  //     faceResult = s;
  //   });
  //   return s;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(),
        body: Center(
      child: Container(
        //color: Colors.red,
        height: 550,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          //textDirection: TextDirection.rtl,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            logo(),
            //logoUser(),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'تسجيل الدخول الى حسابك', //+'$userEmail'+'$userPassword',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: onChangeEmail,
              //textDirection: TextDirection.rtl,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'البريد الالكترونى',
                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: onChangePassword,
              //textDirection: TextDirection.rtl,
              autofocus: false,
              //initialValue: '',
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'كلمة السر',
                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _loginResult,
              style: const TextStyle(color: Colors.red, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 0),
            _load
                ? const Center(child: CircularProgressIndicator())
                : RawMaterialButton(
                    fillColor: Colors.red,
                    splashColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 100),
                    onPressed: () {
                      _userLogIn(false, null);
                    },
                    shape: const StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('دخــول',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ],
                    ),
                  ),

            const SizedBox(height: 10),
            TextButton(
              child: const Text('لا أتذكر كلمة السر ؟',
                  style: TextStyle(color: Colors.black54)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgetPassword()));
              },
            ),
            TextButton(
              //padding: EdgeInsets.all(0),
              //color: Colors.red,
              child: const Text('مستخدم جديد',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 20)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUp(null)));
              },
            ),
            const SizedBox(height: 20),

            // FacebookSignInButton( onPressed: () { FacebookLogin f =
            //         new FacebookLogin();                 f.logIn(['email']).then((val) {
            //       print(val.accessToken.token);
            //       getFacebookUser(val.accessToken.token).then((u) {
            //         setState(() {
            //           var faceData = json.decode(u.body);
            //           print(faceData);
            //           _usersocialID = faceData['id'];
            //           _userLogIn(true, faceData);
            //         });
            //       });
            //     });
            //   },
            //   text: 'دخول عن طريق فيسبوك',
            // ),
            Text('::$faceResult'),
          ],
        ),
      ),
    ));
  }
}
