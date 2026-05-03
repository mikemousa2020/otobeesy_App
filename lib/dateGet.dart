import 'callApi.dart';
import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:intl/intl.dart' as intl;

String dateFromSelectedPrm = '';
String dateToSelectedPrm = '';

class GetDate extends StatefulWidget {
  final int direction;

  const GetDate(this.direction, {super.key});

  @override
  _State createState() => _State();
}

class _State extends State<GetDate> {
  DateTime
      _value= DateTime.now(); //=this.direction==1?dateFromSelected:dateFromSelected; //= DateTime.now();

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 2));
    if (picked != null) {
      if (widget.direction == 1) {
        myTripGo.date = picked;
        dateFromSelectedPrm = '${picked.day}/${picked.month}/${picked.year}';
      }
      if (widget.direction == 2) {
        myTripCome.date = picked;
        dateToSelectedPrm = '${picked.day}/${picked.month}/${picked.year}';
      }
      //if (widget.direction == 2) dateToSelected = picked;

      setState(() => _value = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    _value = widget.direction == 1
        ? myTripGo.date
        : myTripCome.date; //= DateTime.now();

    return InkWell(
      onTap: () {
        setState(() {});
        if (!(widget.direction == 2 && !isRoundTrip)) _selectDate();
        //widget.direction == 2 && !isRoundTrip ? null : _selectDate();
      },
      child: Container(
        
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: Colors.grey)),
        ),
        padding: const EdgeInsets.only(
          right: 35,
        ),
        margin: const EdgeInsets.only(top: 5.0),
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.date_range),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                ),
                Text(
                  widget.direction == 1 ? 'تاريخ الذهاب' : 'تاريخ العودة',
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            Text(
              //intl.DateFormat.yMd().format(_value),
              getDateStr(_value, widget.direction),

              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    //hit Ctrl+space in intellij to know what are the options you can use in flutter widgets
  }
}

//s = intl.DateFormat('EEE, y/M/d', 'en_US').format(v);
