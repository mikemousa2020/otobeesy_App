import 'dart:convert';
import 'package:flutter/material.dart';
import 'callApi.dart';
import 'myDrawer.dart';

class UserDashboardTrips extends StatefulWidget {
  const UserDashboardTrips({super.key});

  @override
  _UserDashboardTripsState createState() => _UserDashboardTripsState();
}

class _UserDashboardTripsState extends State<UserDashboardTrips> {
  bool _load = false;
  var myTickets = [];

  refresh() {
    setState(() {});
  }

  _getMyTickets() {
    getMyTickets().then((response) {
      //delSeats = new List();

      setState(() {
        myTickets = json.decode(response.body);
        _load = true;
      });
    });
  }

  @override
  initState() {
    super.initState();
    _getMyTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MyDrawer(),
      appBar: myAppBar('التذاكر'),
      body: _load
          ? ListView.builder(
              itemCount: myTickets.length,
              itemBuilder: (context, index) {
                return MyCards(myTickets[index], context, false);

                //crd(myTickets[index], context, false);
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class MyCards extends StatefulWidget {
  final t2;
  final context;
  final isCome;

  const MyCards(this.t2, this.context, this.isCome, {super.key});
  @override
  _MyCardsState createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  String delSeatIDs = '';
  List delSeats = [];

  @override
  Widget build(BuildContext context) {
    var t = widget.t2['myTrips'][0];
    int cardStatusID = t['CardStatusID'];
    String cardStatusDesc = cardStatusID == 4 ? 'مسدد' : 'منتظر السداد';

    return Card(
      margin: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
      child: InkWell(
        onTap: () {},
        child: Container(
            padding: const EdgeInsets.all(5),
            //height: 170.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //textDirection: TextDirection.rtl,
              children: <Widget>[
                Row(
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    const Icon(Icons.date_range),
                    Text(widget.isCome ? 'تاريخ العودة' : 'تاريخ الذهاب'),
                    const Icon(Icons.arrow_back),
                    Text(
                      //'',
                      dateTimeToStr(t['TripDateTime']),
                    ),
                    const SizedBox(width: 20),
                    Text(cardStatusDesc,
                        style: const TextStyle(color: Colors.red, fontSize: 17)),
                  ],
                ),
                Container(
                  //height: 125.0,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '#${t['TripSubData_Id']}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.rtl,
                          ),
                          const Icon(
                            Icons.directions_bus,
                            size: 50.0,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: 100.0,
                            padding: const EdgeInsets.all(2),
                            color: Colors.green,
                            child: Text(
                              //'',
                              t['TripServKind_NameA'].toString(),
                              style: const TextStyle(),
                              textAlign: TextAlign.start,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Text(
                            //'',
                            getTimeStr(t['TripDateTime']),
                            //t['TripDateTime'].toString(),
                            style: const TextStyle(fontSize: 20.0),
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          t['TripOfficeFrom'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800]),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Icon(Icons.arrow_back),
                        ),
                        Text(
                          t['TripOfficeTo'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800]),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 0),
                      child: Wrap(
                        runSpacing: 10,
                        children:
                            //_createChildrenSeats(t['Seats'], t['mySeats']),
                            List<Widget>.generate(t['mySeats'].length,
                                (int index) {
                          var seat = t['mySeats'][index];
                          return InkWell(
                              onTap: () {
                                setState(() {
                                  var seatStatusID = seat['SeatStatusID'];
                                  seatStatusID = seatStatusID == 15 ? 0 : 15;

                                  seat['SeatStatusID'] = seatStatusID;

                                  if (seatStatusID == 15) {
                                    delSeats.add(seat);
                                  } else {
                                    delSeats.remove(seat);
                                  }
                                });
                              },
                              child: SeatDrow(seat));
                        }),
                      ),
                    ),
                      const Text('قم بالضغط على المقاعد المراد الغاؤها',style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          )),
                    const Divider(),  

                    Row(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        Text(
                          '${t['TripSeatsCount']} مقعد',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            '${formatNum(t['TripTotalPrice'])} جنيه',
                            style: const TextStyle(fontSize: 35),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                delSeats.isEmpty
                    ? const Text('')
                    : TextButton(
                        //color: Colors.red,
                        onPressed: () {
                          goTo(context, ConfirmDelete(t, delSeats));
                        },
                        child: const Text('الغاء المحدد'),
                      )
              ],
            )),
      ),
    );
  }
}

class SeatDrow extends StatefulWidget {
  final seat;
  const SeatDrow(this.seat, {super.key});

  @override
  _SeatDrowState createState() => _SeatDrowState();
}

class _SeatDrowState extends State<SeatDrow> {
  //bool del = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 5),
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(widget.seat['SeatStatusID'] == 15
                ? seatImgcanceled
                : seatImgSelected)),
      ),
      child: Text(
        '${widget.seat['SeatNo']}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ConfirmDelete extends StatelessWidget {
  final trip;
  final delSeats;
  //t['TripSubData_Id']
  const ConfirmDelete(this.trip, this.delSeats, {super.key});
  @override
  Widget build(BuildContext context) {
    String delSeatIDs = '';
    delSeats.forEach((s) {
      delSeatIDs = '$delSeatIDs${s['ResID']},';
    });

    return Scaffold(
        endDrawer: MyDrawer(),
        appBar: myAppBar('تأكيد الغاء مقاعد'),
        body: Container(
          child: Column(
            children: <Widget>[
              Text('${trip["CardID"]}'),
              Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      trip['TripOfficeFrom'],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800]),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Icon(Icons.arrow_back),
                    ),
                    Text(
                      trip['TripOfficeTo'],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800]),
                    ),
                  ]),
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(dateTimeToStr(trip['TripDateTime'])),
                  const SizedBox(width: 25),
                  Text(
                    getTimeStr(trip['TripDateTime']),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              Center(
                child: Wrap(
                    runSpacing: 10,
                    children:
                        List<Widget>.generate(delSeats.length, (int index) {
                      return SeatDrow(delSeats[index]);

                      //Text('${delSeats[index]['SeatNo']}');
                    })),
              ),
              const Text('سيتم خصم 10% من القيمة المسدده'),
              const Divider(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  TextButton(
                    //textColor: Colors.white,
                    //color: Colors.green,
                    onPressed: () {
                      cancelSeats(delSeatIDs, trip['CardID']).then((response) {
                        var result = json.decode(response.body);
                        //print(result);
                        if (result != null) {
                          var isSuccess = result['isSuccess'];
                          var result0 = result['Result'];
                          if (isSuccess && result0 == '') {
                            result0 = 'تم الغاء  المقاعد بنجاح';
                          }
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(result0),
                                  actions: <Widget>[
                                    TextButton(
                                      //color: Colors.grey,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();

                                        goTo(context, UserDashboardTrips());
                                      },
                                      child: const Text('موافق'),
                                    )
                                  ],
                                );
                              });
                        }
                      });
                    },
                    child: const Text('تأكيد الالغاء'),
                  ),
                  TextButton(
                    // textColor: Colors.white,
                    // color: Colors.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('اغلاق'),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
