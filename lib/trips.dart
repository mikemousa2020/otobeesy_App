import 'package:flutter/material.dart';
import 'myDrawer.dart';
import 'dart:convert';
import 'callApi.dart';
//mport 'dateGet.dart' as dt;
import 'tripSeats.dart';

class GetTrips extends StatefulWidget {
  const GetTrips({super.key});

  //final getTrips
  @override
  _State createState() => _State();
}



class _State extends State<GetTrips> {
  bool _load = false;

  _getTrips() {
    getTrips().then((response) {
      setState(() {
        trips = json.decode(response.body);
        _load = true;
      });
    });
  }

  @override
  initState() {
    super.initState();
    _getTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.homeBck,
      endDrawer: MyDrawer(),
      appBar:
          myAppBar(getRoundTrip ? 'اختار رحلة العودة' : 'اختار رحلة الذهاب'),
      body: _load
          ? trips.isNotEmpty
              ? Column(
                  children: <Widget>[
                    AppBarEx(trpTitle()),
                    Expanded(
                      child: ListView.builder(
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          return crd(trips[index], context);
                        },
                      ),
                    )
                  ],
                )
              : const Center(
                  child: Text(
                    'عفوا لاتوجد لرحلات لهذه الخيارات',
                    style: TextStyle(color: Colors.redAccent, fontSize: 20),
                  ),
                )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

Card crd(t, context) {
  //DateTime d = DateTime.parse(t['TripDateTime']);
  //DateTime n = DateTime.now();
  //d = d.add(Duration(hours: 4));

 // int i = d.difference(n).inHours;

//assert(d.isAfter(n) == true);
  //bool isNotActive = i <= 4;
  bool isNotActive = t['CanRes'] == 0;

  return Card(
    //color: Colors.red,
    margin: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
    child: InkWell(
        onTap: isNotActive
            ? null
            :
            //msg(context, 'تخطى وقت الحجز المسموح به')

            () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TripSeats(t)));
              },
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: isNotActive ? 0.25 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '#${t['id']}',
                            style: TextStyle(color: myColors.dark),
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.rtl,
                          ),
                          Icon(
                            Icons.directions_bus,
                            size: 45,
                            color: myColors.dark,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '${t['RemainChairs']} مقعد متوفر',
                              style:
                                  const TextStyle(fontSize: 12.0, color: Colors.grey),
                              textAlign: TextAlign.start,
                              textDirection: TextDirection.rtl,
                            ),
                          )
                        ],
                      )),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 7, top: 7),
                            //width: 120,
                            padding: const EdgeInsets.all(0),
                            color: Colors.grey[100],
                            child: Text(
                              t['TripServKind_NameA'].toString(),
                              style: const TextStyle(),
                              textAlign: TextAlign.start,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              child: Text(
                                getTimeStr(t['TripDateTime']),
                                //t['TripDateTime'].toString(),
                                style: TextStyle(
                                    fontSize: 20, color: myColors.dateColor),
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.rtl,
                              )),
                          Container(
                            alignment: Alignment.center,
                            child: const Text(
                              ''
                              //'بعد منتصف الليل'
                              ,
                              style:
                                  TextStyle(fontSize: 12.0, color: Colors.grey),
                              textAlign: TextAlign.start,
                              textDirection: TextDirection.rtl,
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                  Container(
                      color: myColors.dark,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '${t['TripPrice'].toString().replaceAll('.0', '')} جنيه',
                              style: const TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
            isNotActive
                ? Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 50, left: 30),
                    child: Transform.rotate(
                      angle: -14.3 / 45,
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 0, bottom: 0),
                        //color: const Color(0xFFE8581C),
                        child: const Text(
                          'تخطى  وقت  الحجز',
                          style: TextStyle(color: Colors.red, fontSize: 25),
                        ),
                      ),
                    ),
                  )
                : const Text(''),
          ],
        )),
  );
}
