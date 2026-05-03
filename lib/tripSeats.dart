import 'dart:convert';
import 'package:flutter/material.dart';
import 'myDrawer.dart';
import 'callApi.dart';
import 'confirm.dart';

class TripSeats extends StatefulWidget {
  final tripsub;
//t['TripSubData_Id']
  //final int tripSubData_Id;
  const TripSeats(this.tripsub, {super.key});
  @override
  _TripSeatsState createState() => _TripSeatsState();
}

class _TripSeatsState extends State<TripSeats> {
  bool _load = false;

  double h = 100.0;
  _getSeats() {
    getTripSeats(widget.tripsub['id']).then((response) {
      setState(() {
        seats = json.decode(response.body);
        //if (seats != null) {
          h = 500.0;
          for (var s in seats) {
            h = s['PosY'] > h ? s['PosY'] : h;
          }
          //h = h + 15.0;
        //}
        _load = true;
      });
    });
  }

  @override
  initState() {
    super.initState();
    _getSeats();
    //myTripGo.trip = widget.tripsub;
  }

  List<Widget> listW() {
    List<Widget> list = [];
    Widget w;
    double x = 0.9;
    double y = 1.4;

    String seatImgName = ''; // = seatImgBooked;

    for (int i = 0; i < seats.length; ++i) {
      if (seats[i]["SeatNo"] > 0) {
        seatImgName = seats[i]["Status"] == 0 ? seatImgFree : seatImgBooked;
        if (seats[i]["Status"] == 100) {
          seatImgName = seatImgSelected;
        } else if (seats[i]["Status"] == 0)
          seatImgName = seatImgFree;
        else
          seatImgName = seatImgBooked;

        w = Positioned(
          //color: Colors.red,
          width: 45,
          height: 45,
          left: seats[i]["PosX"] * x - 20.0,
          top: seats[i]["PosY"] * y,
          child: InkWell(
            onTap: seats[i]['Status'] != 0 && seats[i]['Status'] != 100
                ? null
                : () {
                    if (seats[i]['Status'] == 0) {
                      int v = seats.where((x) => x['Status'] == 100).length;
                      if (v < 8) {
                        seats[i]['Status'] = 100;
                      } else {
                        msg(context, 'لايمكن تحديد اكثر من 8 مقاعد');
                      }
                    } else if (seats[i]['Status'] == 100)
                      seats[i]['Status'] = 0;

                    setState(() {
                      //myTripGo.seatsCount = 0;
                      //seats.forEach((s) =>myTripGo.seatsCount += s['Status'] == 100 ? 1 : 0);
                      //setSelectedseats(seats);
                    });
                  },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(seatImgName),
                ),
              ),
              //color: seats[i]["Status"] == 0 ? Colors.green : Colors.grey,
              child: Text(
                '${seats[i]["SeatNo"]}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
        list.add(w);
      }
    }

    return list;
  }

  //List<Widget> listW;
  @override
  Widget build(BuildContext context) {
    int cnt = seats.where((x) => x['Status'] == 100).length;

    return Scaffold(
      backgroundColor: myColors.homeBck,
      endDrawer: MyDrawer(),
      appBar: myAppBar(
          getRoundTrip ? 'اختيار مقاعد العودة' : 'اختيار مقاعد الذهاب'),
      body: Column(
        children: <Widget>[
          AppBarEx(trpTitle()),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 1, right: 1),
              children: <Widget>[
                Card(
                    margin: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              textDirection: TextDirection.rtl,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          'محجوز' ' ',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          maxRadius: 8.0,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        const Text(
                                          'متـاح' '  ',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        CircleAvatar(
                                          backgroundColor: myColors.seatFree,
                                          maxRadius: 8.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      width: 100.0,
                                      padding: const EdgeInsets.all(0.0),
                                      color: Colors.grey[50],
                                      child: Text(
                                        widget.tripsub['TripServKind_NameA']
                                            .toString(),
                                        style: const TextStyle(),
                                      ),
                                    ),
                                    Text(
                                      getTimeStr(
                                          widget.tripsub['TripDateTime']),
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                          color: Colors
                                              .black, // Color(0xFF063D7D),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      '${widget.tripsub['TripPrice']
                                              .toString()
                                              .replaceAll('.0', '')} جنيه',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          color: myColors
                                              .dark, // Color(0xFF4A90E2),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(
                                      Icons.directions_bus,
                                      size: 40.0,
                                      color:
                                          Colors.black54, // Color(0xFF063D7D),
                                    )
                                  ],
                                ),
                              ],
                            )
                            //padding: EdgeInsets.only(top: 10.0, left: 0.0),
                            //height: 100,

                            ),
                        const Divider(),
                        Container(
                          padding: const EdgeInsets.only(top: 10.0, left: 0.0),
                          height: h * 1.4 + (h * 1.4) * 0.10 + 50,
                          child: _load
                              ? Stack(
                                  children: listW(),
                                )
                              : const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: RawMaterialButton(
        fillColor: seats.where((x) => x['Status'] == 100).isEmpty
            ? Colors.transparent
            : myColors.btnBck,
        onPressed: () {
          seatsSelected = seats.where((x) => x['Status'] == 100).toList();
          //myTripGo.trip = widget.tripsub;

          if (seatsSelected.isNotEmpty) {
            if (!getRoundTrip) {
              myTripGo.trip = widget.tripsub;
            } else {
              myTripCome.trip = widget.tripsub;
            }

            setTripseats(seatsSelected);
            if (isRoundTrip && !getRoundTrip) {
              getRoundTrip = true;
              pageTrips(context);
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Confirm()));
            }
          }
        },
        shape: const StadiumBorder(),
        child: Container(
          width: MediaQuery.of(context).size.width - 30,
          //height: 40,
          //margin: EdgeInsets.only(left: 200),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                    child: Text(
                  cnt == 0 ? '' : '$cnt',
                  style: TextStyle(color: Colors.red[200],fontSize: 12),
                  textAlign: TextAlign.center,
                )
                    // CircleAvatar(
                    //   backgroundColor: Colors.brown.shade800,
                    //   child: Text(''),
                    // ),
                    ),
              ), // remove 1

              Expanded(
                  flex: 4,
                  child: Container(
                      child: Text(
                    'التالى',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ))),
              Expanded(
                flex: 1,
                child: Text(''),
              ), // r
            ],
          ),
        ),
      ),
    );
  }
}
