import 'package:flutter/material.dart';
import 'myDrawer.dart';
import 'callApi.dart';
import 'myClasses.dart';
//import 'callApi_Classes.dart';
//import 'myDrawer.dart';
import 'logIn.dart';
import 'booking.dart';

class Confirm extends StatelessWidget {
  const Confirm({super.key});

  @override
  Widget build(BuildContext context) {
    //setSelectedseats(seats);
    return Scaffold(
      endDrawer: MyDrawer(),
      appBar: myAppBar('تأكيد الحجز'),
      body: Column(
        children: <Widget>[
          AppBarEx(confirmTitle(false)),
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  child: crd(myTripGo, context, false),
                ),
                isRoundTrip
                    ? Container(
                        child: crd(myTripCome, context, true),
                      )
                    : const Text(''),
                const SizedBox(height: 100)
              ],
            ),
          )
        ],
      ),
      floatingActionButton: RawMaterialButton(
        fillColor: myColors.btnBck,
        onPressed: () {
          ( user.userID > 0)
              ? goTo(context, Booking())
              : goTo(context, LogIn());
        },
        shape: const StadiumBorder(),
        child: Container(
          width: MediaQuery.of(context).size.width - 30,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'تأكيـــد',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Card crd(t, context, bool isCome) {
  //var t=t2.trip;
  double price =
      isRoundTrip ? t.trip['TripPrice_GoCome'] * 0.5 : t.trip['TripPrice'];

  print(t.trip);
  return Card(
    margin: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
    child: InkWell(
      onTap: () {},
      child: Container(
          padding: const EdgeInsets.all(5),
          //height: 170.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  const Icon(Icons.date_range),
                  Text(isCome ? 'تاريخ العودة' : 'تاريخ الذهاب'),
                  const SizedBox(width: 15),
                  const Icon(Icons.arrow_back, size: 25, color: Colors.black),
                  const SizedBox(width: 15),
                  Text(
                    dateTimeToStr(t.trip['TripDateTime']),
                  )
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
                          '#${t.trip['TripData_Id']}',
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: 150,
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 1, bottom: 1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color:Colors.grey[100],// myColors.goComeBckAll,
                              ),
                          //color: Colors.grey[200],
                          child: Text(
                            t.trip['TripServKind_NameA'].toString(),
                            //style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        
                        Text(
                          getTimeStr(t.trip['TripDateTime']),
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
              const Divider(),
              Column(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('من'),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      const Icon(
                        Icons.radio_button_unchecked,
                        color: Colors.black,
                        size: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                      ),
                      Text(
                        //goTripSelected['TripOfficeFrom_NameA'],
                        officeNameFrom.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Text('الى'),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      const Icon(
                        Icons.fiber_manual_record,
                        color: Colors.green,
                        size: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                      ),
                      Text(
                        //goTripSelected['TripOfficeTo_NameA'],
                        officeNameTo.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Wrap(
                      runSpacing: 10,
                      children: _createChildrenSeats(t.seats),
                    ),
                  ),
                  const Divider(),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        '${t.seatsCount} مقعد × ${formatNum(price)} جنيه',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Text(
                          //formatNum(cardTotal) + ' ' + 'جنيه',
                          '${formatNum(t.seatsCount * price)} جنيه',

                          style: const TextStyle(fontSize: 35),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          )),
    ),
  );
}

Card crd2(MyTrip t, context, bool isCome) {
  //print(t);

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
              Wrap(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  const Icon(
                    Icons.date_range,
                    color: Colors.black,
                  ),
                  Text(isCome ? 'عودة' : 'ذهاب'),
                  const Icon(Icons.arrow_back, size: 25, color: Colors.black),
                  //Icon(Icons.arrow_back, Colors.red),
                  Text(dateTimeToStr(t.trip['TripDateTime'])),
                  const SizedBox(width: 20),
                  Text(
                    getTimeStr(t.trip['TripDateTime']),
                    style: const TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl,
                  ),
                  Container(
                    alignment: Alignment.center,
                    //width: 90,
                    padding: const EdgeInsets.all(2),
                    color: Colors.grey[50],
                    child: Text(
                      t.trip['TripServKind_NameA'].toString(),
                      style: const TextStyle(),
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
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
                        isCome ? officeNameTo : officeNameFrom,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: myColors.dark),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child:
                            //Icon(Icons.arrow_back),
                            Icon(Icons.arrow_back, size: 25, color: Colors.red),
                      ),
                      Text(
                        !isCome ? officeNameTo : officeNameFrom,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: myColors.dark),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 0),
                    child: Wrap(
                      runSpacing: 10,
                      children: _createChildrenSeats(t.seats),
                    ),
                  ),
                  const Divider(
                    height: 5,
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        '${t.seatsCount} مقعد × ${formatNum(t.tripPrice)} جنيه',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Text(
                          '${formatNum(t.seatsCount * t.tripPrice)} جنيه',
                          style: const TextStyle(fontSize: 20),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          )),
    ),
  );
}

List<Widget> _createChildrenSeats(List seats) {
  return List<Widget>.generate(seats.length, (int index) {
    return seatDrow(seats[index]);
  });
}

Widget seatDrow(var seat) {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.only(right: 5),
    //padding: EdgeInsets.only(top: 2),
    width: 45,
    height: 45,
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(seatImgSelected),
      ),
    ),
    child: Text(
      '${seat["SeatNo"]}',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
