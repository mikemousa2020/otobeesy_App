import 'dart:convert';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'booking_NewPayByCredit.dart';
import 'booking_PayByFawry.dart';
import 'callApi.dart';
import 'myDrawer.dart';
import 'booking_Header.dart';
//import 'booking_PayByCredit.dart';
//import 'booking_PayByFawry.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  bool _load = false;
  String fawryTxt = 'سداد الكترونى';
  String holdResult = '';

  _getCnf() {
    getCnfg('AppFwryMsg').then((response) {
      setState(() {
        fawryTxt = json.decode(response.body);
      });
    });
  }

  _hold() {
    holdSeats().then((response) {
      card = json.decode(response.body);
      cardID = card['CardID'] ?? 0;
      cardToken = card['CardToken'] ?? '';
      holdResult = card['Result'] ?? '';
      if (cardID == 0) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('موافق'),
                  )
                ],
                content: Container(
                  //height: 100,
                  child: Text(holdResult),
                ),
              );
            });
      }
      //print(card);
      //print(cardID);
      setState(() {
        _load = true;
      });
    });
  }

  @override
  initState() {
    super.initState();
    _hold();
    _getCnf();
  }

  @override
  Widget build(BuildContext context) {
    return !_load
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            endDrawer: MyDrawer(),
            appBar: myAppBar('اختار طريقة السداد'),
            body: cardID > 0 && holdResult == ""
                ? ListView(
                    children: <Widget>[
                      AppBarEx(confirmTitle(false)),
                      BookingHeader(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingNewPayByCredit()));
                        },
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: <Widget>[
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  'بطاقة ائتمان',
                                  style: TextStyle(
                                      //color: Color(0xFF4A4A4A),
                                      ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Image(
                                  image: AssetImage(imgvisa),
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Text(''),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Icon(
                                      Icons.chevron_left,
                                      color: Color(0xFF4A4A4A),
                                      size: 40.0,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      //Divider(),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingPayByFawry()));
                        },
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text(
                                  fawryTxt,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Icon(
                                      Icons.chevron_left,
                                      color: Color(0xFF4A4A4A),
                                      size: 40.0,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(holdResult),
          );
  }
}
