import 'package:flutter/material.dart';
import 'logIn.dart';
import 'terms.dart';
import 'callApi.dart';
import 'myClasses.dart';
import 'contactus.dart';
import 'homePage.dart';
//import 'logIn.dart';
import 'userDashboardPassword.dart';
import 'userDashboardTrips.dart';
import 'userDashboardprofile.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          child: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10),
            height: 150,
            color: myColors.dark,
            child: Column(
              children: <Widget>[
                myPic(),
                Text(
                  user.userEmail,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          //onPressed: () {              Navigator.push(context,                  new MaterialPageRoute(builder: (context) => HomePage()));
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              //الشاشة الرئيسية
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: const Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.home,
                    size: 35,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 30),
                  Text(
                    'الشاشة الرئيسية',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text('')
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              // اتصل بنا
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Contactus()));
              },
              child: const Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.phone_in_talk,
                    size: 35,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 30),
                  Text(
                    'اتصل بنا',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text('')
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              // الشروط والاحكام
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Terms()));
              },
              child: const Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.ad_units,
                    size: 35,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 30),
                  Text(
                    'الشروط والاحكام',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text('')
                ],
              ),
            ),
          ),

          const Divider(
            height: 10,
          ),

          ( user.userID > 0)
              ? Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    //textDirection: TextDirection.rtl,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      InkWell(
                        // التذاكر
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserDashboardTrips()));
                        },
                        child: const Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.receipt,
                              size: 35,
                              color: Colors.black,
                            ),
                            SizedBox(width: 30),
                            Text(
                              'التذاكر',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text('')
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        // حسابى
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserDashboardprofile()));
                        },

                        child: const Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.account_circle,
                              size: 35,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 30),
                            Text(
                              'بيانات حسابى',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text('')
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserDashboardPassword()));
                        },
                        child: const Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.https,
                              size: 35,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 30),
                            Text(
                              'تغيير كلمة السر',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text('')
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 5),
                      InkWell(
                        // تسجيل الخروج
                        onTap: () {
                          setState(() {
                            user = User();
                            writeData('');
                          });
                        },
                        child: const Row(
                          textDirection: TextDirection.rtl,

                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.input,
                              size: 35,
                              color: Colors.red,
                            ),
                            SizedBox(width: 30),
                            Text(
                              'تسجيل الخروج',
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                            Text('')
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    //دخول مستخدم
                    onTap: () {
                      //Navigator.pop(context,true);

                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyDrawer()));

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LogIn()));
                    },
                    child: const Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          size: 35,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 30),
                        Text(
                          'دخول مستخدم',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      )),
    );
  }
}
