import 'package:flutter/material.dart';
import 'callApi.dart';

class RoundTripOpt extends StatefulWidget {
  final Function() notifyParent;
  //RoundTripOpt({Key key,  this.notifyParent}) : super(key: key);

  const RoundTripOpt( this.notifyParent, {super.key}) ;



  @override
  _RoundTripOptState createState() => _RoundTripOptState();
}

class _RoundTripOptState extends State<RoundTripOpt> {
  //Color clr = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        //color: Colors.red[300],
      ),
      margin: const EdgeInsets.only(top: 7, bottom: 7, left: 10, right: 10),
      alignment: Alignment.center,
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: RawMaterialButton(
                //fillColor: !isRoundTrip ? myColors.appBar : null,
                fillColor: !isRoundTrip ? myColors.goComeBtnActiveBck : null,
                animationDuration: const Duration(seconds: 10),
                onPressed: () {
                  setState(() {
                    isRoundTrip = false;
                  });
                  widget.notifyParent();
                },
                shape: const StadiumBorder(),
                child: Text(
                  'ذهاب فقط',
                  style: TextStyle(
                      color: !isRoundTrip ? myColors.goComeBtnActive : myColors.goComeBtnActiveNot),
                ),
              )),
          Expanded(
              flex: 1,
              child: RawMaterialButton(
                //fillColor: isRoundTrip ? myColors.appBar : null,
                fillColor: isRoundTrip ? myColors.goComeBtnActiveBck : null,
                animationDuration: const Duration(seconds: 10),
                onPressed: () {
                  setState(() {
                    isRoundTrip = true;
                  });
                  widget.notifyParent();
                },
                shape: const StadiumBorder(),
                child: Text(
                  'ذهاب وعودة',
                  style: TextStyle(
                      //color: isRoundTrip ? Colors.white : Colors.black),
                      color: isRoundTrip ? myColors.goComeBtnActive : myColors.goComeBtnActiveNot),

                ),
              )),
        ],
      ),
      //Text('Round Trip     One Way'),
    );
  }
}
