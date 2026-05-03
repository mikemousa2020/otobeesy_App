import 'dart:io';
import 'package:flutter/material.dart';
//import 'myDrawer.dart';
import 'dart:convert';
import '_getOfficeList.dart';
//import '_roundTripOpt_Pnl.dart';
import '_roundTripOpt_Pnl.dart';
import 'callApi.dart';
import 'myDrawer.dart';
//import '_getOfficeList.dart';
//import '_roundTripOpt_Pnl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final _homeKey = GlobalKey<ScaffoldState>();

  bool _load = false;
  String appVer = '';
  bool mustUpdate = false;

  int i = 0;
  void sel(int C) {
    selCode = C; // v.toString();
    setState(() {});
  }

  _refresh() {
    setState(() {});
  }

  _getOffices() {
    if ( offices.isEmpty) {
      officeNameFrom = '...'; // '*****' + i.toString();
      officeNameTo = '...'; // '******' + i.toString();
      getOffices().then((response) {
        offices = json.decode(response);
        setState(() {
          _load = true;
        });
      });
    } else {
      setState(() {
        _load = true;
      });
    }
  }

  _getCoupons() {
    if ( coupon.couponCode == '') {
      getCoupons().then((response) {
        var c = json.decode(response.body);
        coupon.couponCode = c['couponCode'];
        coupon.couponDescription = c['couponDescription'];
        coupon.couponLabel = c['couponLabel'];
        coupon.couponName = c['couponName'];
        setState(() {});
      });
    }
  }

  _getVer() {
    getAppVer().then((response) {
      try {
        var lastVer = json.decode(response.body);
 
        double v = double.parse(lastVer);

        mustUpdate = v > ver;
      } catch (Ex) {
        print(Ex);
      }

      if (mustUpdate) {
        setState(() {
          _load = true;
        });
      }
    });
  }

  @override
  initState() {
    _getVer();
    print(mustUpdate);
    _getOffices();
    _getCoupons();
    //_getVer();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return !_load
        ? Scaffold(
            key: _homeKey,
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                logo(),
                const SizedBox(
                  height: 50,
                ),
                wait(),
                //SizedBox(height: 10,),
                //Text('رجاء الانتظار'),
              ],
            )),
          )
        : mustUpdate
            ? Scaffold(
                key: _homeKey,
                body: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    logo(),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: const Text(
                          'عفوا هذا اصدار قديم برجاء الحصول على اخر اصدار',
                          style: TextStyle(fontSize: 22),
                          textAlign: TextAlign.center,
                        ))

                    //SizedBox(height: 10,),
                    //Text('رجاء الانتظار'),
                  ],
                )),
              )
            : Form(
                // ignore: deprecated_member_use
                onWillPop: () {
                  exit(0);
                  //return null;
                },
                child: Scaffold(
                  backgroundColor: myColors.homeBck,
                  endDrawer: MyDrawer(),
                  appBar:myAppBar('البحث عن رحلتك'),
                  floatingActionButton: RawMaterialButton(
                    fillColor:   myColors.btnBck,
                    onPressed: () {
                      getRoundTrip = false;
                      pageTrips(context);
                    },
                    shape: const StadiumBorder(),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'بحث',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: ListView(
                    children: <Widget>[
                      AppBarEx(RoundTripOpt( _refresh)),
                      Container(
                        padding: const EdgeInsets.only(top: 5, left: 0.0, right: 0.0),
                        color: const Color(0xffF2F2F2),
                        //height: 230,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 20),
                            OfficePnl(context, 1),
                            const SizedBox(height: 15),
                            const Divider(color: Colors.black),
                            OfficePnl(context, 2),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                      Container(
                          // padding: EdgeInsets.only(right: 30),
                          color: Colors.white,
                          //height: 72,
                          child: Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              pnldate(context, 1),
                              isRoundTrip ? pnldate(context, 2) : const Text(''),
                            ],
                          )),

                      //Divider(color: Colors.black),
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //       top: 20, left: 30, right: 30, bottom: 0),
                      //   child: RawMaterialButton(
                      //     fillColor: myColors.btnBck,
                      //     splashColor: myColors.btnBck,
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //         vertical: 8.0,
                      //         horizontal: 20.0,
                      //       ),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: <Widget>[
                      //           Padding(
                      //             padding: EdgeInsets.only(left: 20.0),
                      //           ),
                      //           Text('بـحـث',
                      //               style: TextStyle(
                      //                   fontSize: 20.0, color: myColors.searchbtn)),
                      //         ],
                      //       ),
                      //     ),
                      //     onPressed: () {
                      //       getRoundTrip = false;
                      //       pageTrips(context);
                      //     },
                      //     shape: StadiumBorder(),
                      //   ),
                      // ),

                      const SizedBox(height: 10),

                      coupon.couponCode == ""
                          ? const Text('')
                          : Container(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(children: <Widget>[
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  textDirection: TextDirection.rtl,
                                  children: <Widget>[
                                    const Text('استخدم البرموكود'),
                                    const SizedBox(width: 10),
                                    Text(
                                      coupon.couponCode,
                                      style: const TextStyle(
                                          color: Colors.orange,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(
                                  coupon.couponName,
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textDirection: TextDirection.rtl,
                                ),
                              ])),
                      ( user.userID == 0)
                          ? FutureBuilder(
                              initialData: "Loading text..",
                              future: readData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> text) {
                                if (text.hasData) {
                                  String? txt = text.data;
                                  var s = txt?.split(',');
                                  if (s!.length > 3) {
                                    bool userIsFace = s[3] == 'true';
                                    String userEmail = userIsFace ? '' : s[0],
                                        userPassword = s[1],
                                        //_userID = s[2],
                                        usersocialID = s[4];

                                    login(usersocialID, userEmail,
                                            userPassword)
                                        .then((response) {
                                      var u = json.decode(response.body);
                                      if (u != null &&
                                          u['UserID'] != null &&
                                          u['UserID'] > 0) {
                                        user.userToken = u['UserToken'] ?? '';
                                        user.userID = u['UserID'];
                                        user.userPassword = userPassword;
                                        user.userIsFace = false;
                                        user.usersocialID = '';
                                        user.userPicUrl = u['Pic_Url'] ?? '';
                                        user.userEmail = u['UserEmail'] ?? '';
                                        user.userName = u['UserName'] ?? '';
                                        user.userTelNo = u['UserTelNo'] ?? '';
                                      }
                                    });
                                  }

                                  //return Text(text.data);
                                  return const Text('');
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              })
                          : const Text(''),
                      // GetAppVer(),
                    ],
                  ),
                ));
  }
}

class GetAppVer extends StatefulWidget {
  const GetAppVer({super.key});

  @override
  _GetAppVerState createState() => _GetAppVerState();
}

class _GetAppVerState extends State<GetAppVer> {
  String platformVersion='', projectCode='', projectVersion='', appID='', appName='';
  // getV() {
  //   try {
  //     GetVersion.platformVersion.then((v) {
  //       platformVersion = v;
  //     });
  //     GetVersion.projectCode.then((v) {
  //       projectCode = v;
  //     });
  //     GetVersion.projectVersion.then((v) {
  //       projectVersion = v;
  //     });
  //     GetVersion.appID.then((v) {
  //       appID = v;
  //     });
  //     GetVersion.appName.then((v) {
  //       appName = v;
  //     });
  //     setState(() {});
  //   } catch (Ex) {}
  // }

  @override
  Widget build(BuildContext context) {
    // getV();
    String txt =
        'projectVersion:$projectVersion , appID:$appID , appName:$appName , platformVersion:$platformVersion , projectCode:$projectCode ';

    return Container(
        child: Text(
      txt,
      style: const TextStyle(color: Colors.grey, fontSize: 10),
    ));
  }
}
