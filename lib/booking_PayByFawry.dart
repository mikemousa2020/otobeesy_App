import 'package:flutter/material.dart';
import 'homePage.dart';
import 'callApi.dart';
import 'myDrawer.dart';
import 'dart:convert';

class BookingPayByFawry extends StatefulWidget {
  const BookingPayByFawry({super.key});

  @override
  _BookingPayByFawryState createState() => _BookingPayByFawryState();
}

class _BookingPayByFawryState extends State<BookingPayByFawry> {
  bool _load = false;
  int jobID = 0;
  String fawryIntrvalMsg = 'مدة صلاحية هذا الرقم 3 ساعات';
  String fawryErr = '';
  String fawryImgUrl = '${apiUrl}img/new/all.jpg';
  _hold() {
    fawrySave().then((response) {
      var fawry = json.decode(response.body);
      print(fawry);
      setState(() {
        _load = true;
        if (fawry != null) {
          fawryErr = fawry['Result'];
          jobID = fawry['JobID'];
          if (fawry['fawryIntrvalMsg'] != null &&
              fawry['fawryIntrvalMsg'] != '') {
            fawryIntrvalMsg = fawry['fawryIntrvalMsg'];
          }
        }
        //else fawryErr = '';
      });
      print('jobID:$jobID');
    });
  }

  @override
  initState() {
    super.initState();
    _hold();
  }

  @override
  Widget build(BuildContext context) {
    return !_load
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            endDrawer: MyDrawer(),
            appBar: myAppBar('سداد الكترونى'),
            body: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppBarEx(confirmTitle(true)),
                const SizedBox(
                  height: 20,
                ),
                //BookingHeader(),
                Container(
                  //height: 50,
                  //width: MediaQuery,
                  padding: const EdgeInsets.all(5),
                  color: const Color(0xFFFFD328),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //fawryImg
                      Image.network(
                        'https://otobeesy.com/img/new/all.jpg',
                        fit: BoxFit.fitWidth,
                        height: 50,
                      ),
                      // Image(
                      //   fit: BoxFit.cover,
                      //   image: AssetImage('$imgfawry'),
                      //   height: 50,
                      // )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 15),
                      ),
                      const Text(
                        'ادفع فى اى منفذ تحصيل  بالرقم التالى',
                        style: TextStyle(),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        jobID > 0 ? jobID.toString() : 'خطأ:$fawryErr',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: jobID > 0 ? 50 : 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        fawryIntrvalMsg,
                        style: const TextStyle(),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        height: 70,
                        child: RawMaterialButton(
                          fillColor: Colors.green,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                          shape: const StadiumBorder(),
                          //splashColor: Colors.greenAccent,
                          child: Text(
                            'الشاشة الرئيسية',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }
}
